import 'dart:convert';
import 'package:http/http.dart' as http;

/// Consumo da API pública ViaCEP (RF007) para buscar endereço a partir do CEP.
/// https://viacep.com.br/
class CepService {
  Future<EnderecoViaCep> buscarPorCep(String cep) async {
    final cepLimpo = cep.replaceAll(RegExp(r'[^0-9]'), '');

    if (cepLimpo.length != 8) {
      throw Exception('CEP inválido. Informe 8 dígitos.');
    }

    final url = Uri.parse('https://viacep.com.br/ws/$cepLimpo/json/');

    final resposta = await http.get(url);

    if (resposta.statusCode != 200) {
      throw Exception('Falha ao consultar o CEP. Tente novamente.');
    }

    final json = jsonDecode(resposta.body) as Map<String, dynamic>;

    if (json['erro'] == true) {
      throw Exception('CEP não encontrado.');
    }

    return EnderecoViaCep.fromJson(json);
  }
}

class EnderecoViaCep {
  final String logradouro;
  final String bairro;
  final String cidade;
  final String uf;

  EnderecoViaCep({
    required this.logradouro,
    required this.bairro,
    required this.cidade,
    required this.uf,
  });

  factory EnderecoViaCep.fromJson(Map<String, dynamic> json) {
    return EnderecoViaCep(
      logradouro: json['logradouro'] ?? '',
      bairro: json['bairro'] ?? '',
      cidade: json['localidade'] ?? '',
      uf: json['uf'] ?? '',
    );
  }

  /// Texto formatado para exibição/armazenamento.
  String get completo {
    final partes = [logradouro, bairro, '$cidade - $uf']
        .where((p) => p.trim().isNotEmpty && p != ' - ')
        .toList();
    return partes.join(', ');
  }
}
