import 'package:flutter/material.dart';
import 'package:mobile_pi/desenho/cores.dart';
import 'package:mobile_pi/service/play_global.dart';
import 'package:mobile_pi/telas/player_page.dart';
import 'package:just_audio/just_audio.dart';

class MiniPlayer extends StatefulWidget {
  const MiniPlayer({super.key});

  @override
  State<MiniPlayer> createState() => _MiniPlayerState();
}

class _MiniPlayerState extends State<MiniPlayer> {
  final c = Cores();

  Duration posicao = Duration.zero;
  Duration duracao = Duration.zero;

  @override
  void initState() {
    super.initState();

    // 🔄 posição atual
    PlayerStateGlobal.player.positionStream.listen((p) {
      if (!mounted) return;
      setState(() => posicao = p);
    });

    // ⏱️ duração total
    PlayerStateGlobal.player.durationStream.listen((d) {
      if (!mounted || d == null) return;
      setState(() => duracao = d);
    });

    // 🎵 troca de música na playlist
    PlayerStateGlobal.player.currentIndexStream.listen((index) {
      if (!mounted) return;

      if (index != null &&
          PlayerStateGlobal.playlist.isNotEmpty &&
          index < PlayerStateGlobal.playlist.length) {
        final musica = PlayerStateGlobal.playlist[index];

        setState(() {
          PlayerStateGlobal.indexAtual = index;
          PlayerStateGlobal.titulo = musica['titulo'];
          PlayerStateGlobal.artista = musica['artista'];
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final largura = MediaQuery.of(context).size.width;

    return StreamBuilder<PlayerState>(
      stream: PlayerStateGlobal.player.playerStateStream,
      builder: (context, snapshot) {
        final player = PlayerStateGlobal.player;

        if (player.audioSource == null) {
          return const SizedBox(height: 43);
        }

        final playing = snapshot.data?.playing ?? false;

        final max = duracao.inSeconds > 0 ? duracao.inSeconds : 1;
        final value = posicao.inSeconds.clamp(0, max);

        return InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () {
            Navigator.push(
              context,
              PageRouteBuilder(
                opaque: false,
                pageBuilder: (_, __, ___) => const PlayerPage(),
                transitionsBuilder: (_, animation, __, child) {
                  return SlideTransition(
                    position: Tween(
                      begin: const Offset(0, 1),
                      end: Offset.zero,
                    ).animate(animation),
                    child: child,
                  );
                },
              ),
            );
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Container(
              height: 43,
              width: largura - 10,
              color: c.azul(),
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 5),
                  // ---------------- INFO + CONTROLES ----------------
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.music_note, color: c.branco1()),
                          const SizedBox(width: 6),
                          SizedBox(
                            width: largura * 0.55,
                            child: Text(
                              PlayerStateGlobal.titulo ?? '',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(color: c.branco1()),
                            ),
                          ),
                        ],
                      ),

                      IconButton(
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        icon: Icon(
                          playing ? Icons.pause : Icons.play_arrow,
                          color: c.branco(),
                        ),
                        onPressed: () {
                          playing
                              ? player.pause()
                              : player.play();
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                  // ---------------- SLIDER ----------------
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      trackHeight: 2,
                      activeTrackColor: c.laranja(),
                      inactiveTrackColor: Colors.white24,
                      thumbShape: SliderComponentShape.noThumb,
                      overlayShape: SliderComponentShape.noOverlay,
                    ),
                    child: Slider(
                      min: 0,
                      max: max.toDouble(),
                      value: value.toDouble(),
                      onChanged: (v) {
                        player.seek(Duration(seconds: v.toInt()));
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
