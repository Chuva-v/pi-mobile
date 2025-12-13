import 'package:flutter/material.dart';
import 'package:mobile_pi/desenho/cores.dart';
import 'package:mobile_pi/service/play_global.dart';

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

    PlayerStateGlobal.player.positionStream.listen((p) {
      if (mounted) setState(() => posicao = p);
    });

    PlayerStateGlobal.player.durationStream.listen((d) {
      if (mounted && d != null) {
        setState(() => duracao = d);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double largura = MediaQuery.sizeOf(context).width;
    final duracaoSegundos = duracao.inSeconds;
    final posicaoSegundos = posicao.inSeconds;

    return StreamBuilder(
      stream: PlayerStateGlobal.player.playerStateStream,
      builder: (context, snapshot) {
        final playing = PlayerStateGlobal.player.playing;

        if (!PlayerStateGlobal.tocando) {
          return const SizedBox(height: 43,);
        }

        return ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Container(
            height: 43,
            width: largura - 10,
            color: c.azul(),
            padding: EdgeInsets.symmetric(horizontal: 4),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.music_note, color: c.fundo()),
                        SizedBox(width: 8),
                        Text(
                          PlayerStateGlobal.titulo ?? '',
                          style: TextStyle(color: c.fundo()),
                        ),
                      ],
                    ),

                    IconButton(
                      onPressed: () {
                        playing
                          ? PlayerStateGlobal.player.pause()
                          : PlayerStateGlobal.player.play();
                      },
                      icon: Icon(
                        playing ? Icons.pause : Icons.play_arrow,
                        color: c.branco(),
                      ),
                    ),
                  ],
                ),

                if (duracaoSegundos > 0)
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
                      max: duracaoSegundos.toDouble(),
                      value: posicaoSegundos
                          .clamp(0, duracaoSegundos)
                          .toDouble(),
                      onChanged: (value) {
                        PlayerStateGlobal.player
                            .seek(Duration(seconds: value.toInt()));
                      },
                    ),
                  )
                else
                  const SizedBox(height: 2),
              ],
            ),
          ),
        );
      },
    );
  }
}
