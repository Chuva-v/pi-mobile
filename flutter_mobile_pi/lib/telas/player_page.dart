import 'package:flutter/material.dart';
import 'package:mobile_pi/desenho/cores.dart';
import 'package:mobile_pi/service/play_global.dart';
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
    return '${minutos.toString()}:${segundos.toString().padLeft(2, '0')}';
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
              child: Container(
                color: Colors.black.withOpacity(0.35),
              ),
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

                  // -------- CAPA PRINCIPAL --------
                  Container(
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
                  ),

                  const SizedBox(height: 30),

                  // -------- TITULO / ARTISTA --------
                  Column(
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
                  ),

                  const SizedBox(height: 30),

                  // -------- SLIDER + TEMPO --------
                  StreamBuilder<Duration?>(
                    stream: PlayerStateGlobal.player.durationStream,
                    builder: (context, durSnapshot) {
                      final duracao = durSnapshot.data ?? Duration.zero;

                      return StreamBuilder<Duration>(
                        stream: PlayerStateGlobal.player.positionStream,
                        builder: (context, posSnapshot) {
                          final posicao =
                              posSnapshot.data ?? Duration.zero;

                          final max =
                              duracao.inSeconds.toDouble();
                          final value = posicao.inSeconds
                              .clamp(0, duracao.inSeconds)
                              .toDouble();

                          return Column(
                            children: [
                              SliderTheme(
                                data: SliderTheme.of(context).copyWith(
                                  trackHeight: 2,
                                  activeTrackColor: c.laranja(),
                                  inactiveTrackColor: Colors.white24,
                                  thumbShape:
                                      SliderComponentShape.noOverlay,
                                  overlayShape:
                                      SliderComponentShape.noOverlay,
                                ),
                                child: Slider(
                                  min: 0,
                                  max: max > 0 ? max : 1,
                                  value: value,
                                  onChanged: (v) {
                                    PlayerStateGlobal.player.seek(
                                      Duration(seconds: v.toInt()),
                                    );
                                  },
                                ),
                              ),

                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    _formatarTempo(posicao),
                                    style: const TextStyle(
                                        color: Colors.white70,
                                        fontSize: 12),
                                  ),
                                  Text(
                                    _formatarTempo(duracao - posicao),
                                    style: const TextStyle(
                                        color: Colors.white70,
                                        fontSize: 12),
                                  ),
                                ],
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),

                  const SizedBox(height: 30),

                  // -------- CONTROLES --------
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        iconSize: 60,
                        icon: Icon(
                          PlayerStateGlobal.tocando
                              ? Icons.pause_circle
                              : Icons.play_circle,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          setState(() {
                            PlayerStateGlobal.tocando
                                ? PlayerStateGlobal.pause()
                                : PlayerStateGlobal.resume();
                          });
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
        color: Colors.white54,
      ),
    );
  }
}
