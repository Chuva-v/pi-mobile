import 'package:flutter/material.dart';
import 'package:mobile_pi/desenho/cores.dart';
import 'package:mobile_pi/service/play_global.dart';
import 'package:just_audio/just_audio.dart';
import 'dart:ui';

class PlayerPage extends StatefulWidget {
  const PlayerPage({super.key});

  @override
  State<PlayerPage> createState() => _PlayerPageState();
}

class _PlayerPageState extends State<PlayerPage> {
  final c = Cores();

  String _formatarTempo(Duration d) {
    final minutos = d.inMinutes;
    final segundos = d.inSeconds % 60;
    return '$minutos:${segundos.toString().padLeft(2, '0')}';
  }

  IconData _iconeLoop() {
    switch (PlayerStateGlobal.loopMode) {
      case LoopMode.one:
        return Icons.repeat_one;
      case LoopMode.all:
        return Icons.repeat;
      default:
        return Icons.repeat;
    }
  }

  Color _corLoop() {
    return PlayerStateGlobal.loopMode == LoopMode.off
        ? Colors.white54
        : c.laranja();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      // ---------------- APP BAR ----------------
      appBar: AppBar(
        backgroundColor: c.preto(),
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.keyboard_arrow_down,
            size: 32,
            color: c.laranja(),
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),

      // ---------------- BODY ----------------
      body: Stack(
        children: [
          // -------- FUNDO COM CAPA --------
          if (PlayerStateGlobal.capa != null)
            Positioned.fill(
              child: Image.network(
                "http://127.0.0.1:8000/storage/capas/${PlayerStateGlobal.capa}",
                fit: BoxFit.cover,
              ),
            ),

          // -------- BLUR --------
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
              child: Container(color: Colors.black.withOpacity(0.35)),
            ),
          ),

          // -------- GRADIENTE --------
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.2),
                    Colors.black.withOpacity(0.6),
                    Colors.black,
                  ],
                ),
              ),
            ),
          ),

          // -------- CONTEÚDO --------
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // -------- CAPA --------
                  StreamBuilder<int?>(
                    stream: PlayerStateGlobal.player.currentIndexStream,
                    builder: (context, snapshot) {
                      return Container(
                        constraints: const BoxConstraints(maxWidth: 300),
                        height: 300,
                        width: double.infinity,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: PlayerStateGlobal.capa != null
                              ? Image.network(
                                  "http://127.0.0.1:8000/storage/capas/${PlayerStateGlobal.capa}",
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => _capaFallback(),
                                )
                              : _capaFallback(),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 30),

                  // -------- TITULO / ARTISTA --------
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        StreamBuilder<int?>(
                          stream: PlayerStateGlobal.player.currentIndexStream,
                          builder: (context, snapshot) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  PlayerStateGlobal.titulo ?? '',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  PlayerStateGlobal.artista ?? '',
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  // -------- SLIDER --------
                  StreamBuilder<Duration?>(
                    stream: PlayerStateGlobal.player.durationStream,
                    builder: (context, durSnapshot) {
                      final duracao = durSnapshot.data ?? Duration.zero;

                      return StreamBuilder<Duration>(
                        stream: PlayerStateGlobal.player.positionStream,
                        builder: (context, posSnapshot) {
                          final posicao = posSnapshot.data ?? Duration.zero;

                          return Column(
                            children: [
                              Slider(
                                min: 0,
                                max: duracao.inSeconds.toDouble().clamp(1, double.infinity),
                                value: posicao.inSeconds
                                    .toDouble()
                                    .clamp(0, duracao.inSeconds.toDouble()),
                                activeColor: c.laranja(),
                                inactiveColor: Colors.white24,
                                onChanged: (v) {
                                  PlayerStateGlobal.player
                                      .seek(Duration(seconds: v.toInt()));
                                },
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(_formatarTempo(posicao),
                                      style: const TextStyle(
                                          color: Colors.white70,
                                          fontSize: 12)),
                                  Text(_formatarTempo(duracao - posicao),
                                      style: const TextStyle(
                                          color: Colors.white70,
                                          fontSize: 12)),
                                ],
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),

                  const SizedBox(height: 25),

                  // -------- CONTROLES AVANÇADOS --------
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      // SHUFFLE
                      IconButton(
                        icon: Icon(Icons.shuffle,
                            color: PlayerStateGlobal.shuffle
                                ? c.laranja()
                                : Colors.white54),
                        onPressed: () async {
                          await PlayerStateGlobal.toggleShuffle();
                          setState(() {});
                        },
                      ),

                      // ANTERIOR
                      IconButton(
                        icon: const Icon(Icons.skip_previous,
                            size: 36, color: Colors.white),
                        onPressed: PlayerStateGlobal.previous,
                      ),

                      // PLAY / PAUSE
                      StreamBuilder<PlayerState>(
                        stream: PlayerStateGlobal.player.playerStateStream,
                        builder: (context, snapshot) {
                          final playing =
                              snapshot.data?.playing ?? false;

                          return IconButton(
                            iconSize: 70,
                            icon: Icon(
                              playing
                                  ? Icons.pause_circle
                                  : Icons.play_circle,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              playing
                                  ? PlayerStateGlobal.pause()
                                  : PlayerStateGlobal.resume();
                            },
                          );
                        },
                      ),

                      // PRÓXIMA
                      IconButton(
                        icon: const Icon(Icons.skip_next,
                            size: 36, color: Colors.white),
                        onPressed: PlayerStateGlobal.next,
                      ),

                      // LOOP
                      IconButton(
                        icon: Icon(_iconeLoop(), color: _corLoop()),
                        onPressed: () async {
                          await PlayerStateGlobal.toggleLoop();
                          setState(() {});
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _capaFallback() {
    return Container(
      color: Colors.grey[900],
      child: const Icon(
        Icons.music_note,
        size: 120,
        color: Color.fromARGB(255, 215, 130, 3),
      ),
    );
  }
}
