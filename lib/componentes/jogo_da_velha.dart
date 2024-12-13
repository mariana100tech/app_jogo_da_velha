// Suggested code may be subject to a license. Learn more: ~LicenseLog:1486164782.
import 'dart:math';

import 'package:flutter/material.dart';

class JogoDaVelha extends StatefulWidget {
  const JogoDaVelha({super.key});

  @override
  State<JogoDaVelha> createState() => _JogoDaVelhaState();
}

class _JogoDaVelhaState extends State<JogoDaVelha> {
  List<String> _tabuleiro = List.filled(9, '');
  String _jogador = 'x';
  bool _contraMaquina = false;
  final Random _randomico= Random();

  void _iniciarJogo() {
    setState(() {
      _tabuleiro = List.filled(9, '');
      _jogador = 'x';
    });
  }

  void _trocaJogador() {
    setState(() {
      _jogador = _jogador == 'x' ? 'o' : 'x';
    });
  }

  void _mostreDialogoVencedor(String vencedor) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(vencedor == 'Empate' ? 'Empate!' : 'Vencedor: $vencedor'),
          actions: [
            ElevatedButton(
              child: const Text('Reiniciar Jogo'),
              onPressed: () {
                Navigator.of(context).pop;
                _iniciarJogo();
              },
            ),
          ],
        );
      },
    );
  }

  bool _verificaVencedor(String jogador) {
    const pocicoesVencedoras = [
      [0, 1, 2],
      [3, 4, 5],
      [6, 7, 8],
      [0, 3, 6],
      [1, 4, 7],
      [2, 5, 8],
    ];
    for (var posicao in pocicoesVencedoras) {
      if (_tabuleiro[posicao[0]] == jogador &&
          _tabuleiro[posicao[1]] == jogador &&
          _tabuleiro[posicao[2]] == jogador) {
        _mostreDialogoVencedor(jogador);
        return true;
      }
    }
    if (!_tabuleiro.contains('')) {
      _mostreDialogoVencedor('Empate');
      return true;
    }
    return false;
  }

  void _jogadaComputador() {
  Future.delayed(const Duration(seconds: 1), () {
    int movimento;
    do {
      movimento = _randomico.nextInt(9);
    } while (_tabuleiro[movimento] != '');
    setState(() {
      _tabuleiro[movimento] = '0';
      if (!_verificaVencedor(_jogador)) {
        _trocaJogador();
      }
    });
  });
  }

  void _jogada(int index) {
    if (_tabuleiro[index] == '') {
      setState(() {
        _tabuleiro[index] = _jogador;
        if (!_verificaVencedor(_jogador)) {
          _trocaJogador();
          if (_contraMaquina && _jogador == 'O') {
            _jogadaComputador();
          }
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
// Suggested code may be subject to a license. Learn more: ~LicenseLog:1309438036.
    double altura = MediaQuery.of(context).size.height * 0.5;
    return Column(
      children: [
        Expanded(
          child: Row(
            children: [
              Transform.scale(
                scale: 0.6,
                child: Switch(
                  value: _contraMaquina,
                  onChanged: (value) {
                    setState(() {
                      _contraMaquina = value;
                      _iniciarJogo();
                    });
                  },
                ),
              ),
              Text(_contraMaquina ? 'Computador' : 'Humano'),
            ],
          ),
        ),
        Expanded(
          flex: 8,
          child: SizedBox(
            width: altura,
            height: altura,
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 5.0,
                mainAxisSpacing: 5.0,
              ),
              itemCount: 9,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => _jogada(index),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.blue[100],
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Center(
                      child: Text(
                        _tabuleiro[index],
                        style: const TextStyle(fontSize: 40.0),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        Expanded(
          child: ElevatedButton(
            onPressed: _iniciarJogo,
            child: const Text('Reiniciar Jogo'),
          ),
        ),
      ],
    );
  }
}
