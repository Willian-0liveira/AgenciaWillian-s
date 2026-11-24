import 'package:interact/interact.dart';
import 'dart:io';
import '../lib/veiculos.dart';
import '../lib/conexao.dart';

void limparTela() {
  print('\x1B[2J\x1B[0f');
}


void mensagem(String texto) {
  print('''+----------------------------------------------------------------+
                  $texto                                        
+----------------------------------------------------------------+
  ''');
}

String formatarValor(dynamic valor) {
  return 'R\$ ${double.parse(valor.toString()).toStringAsFixed(2)}';
}

Future<void> main() async {
  final supabase = conexao();

  limparTela();

  while (true) {
    mensagem("AGÊNCIA WILLIANS'S");

    final options = [
      '🚘 Cadastrar Veículo',
      '📋 Listar Veículos',
      '✏️ Atualizar Veículo',
      '🗑️ Excluir Veículo',
      '🚪 Sair'
    ];

    final index = Select(
      prompt: 'Escolha uma opção:',
      options: options,
    ).interact();

    limparTela();

    if (index == 0) {
      mensagem('Cadastro de Veiculo');

      print('Marca do veículo:');
      String marca = stdin.readLineSync()!;

      print('Modelo do veículo:');
      String modelo = stdin.readLineSync()!;

      print('Ano do veículo:');
      int ano = int.parse(stdin.readLineSync()!);

      print('Valor do veículo (R\$):');
      double valor = double.parse(stdin.readLineSync()!);

      print('Quilometragem (km):');
      int quilometragem = int.parse(stdin.readLineSync()!);

      if (marca.trim().isNotEmpty &&
          modelo.trim().isNotEmpty &&
          ano >= 1900 &&
          valor > 0 &&
          valor < 10000000000 &&
          quilometragem >= 0) {

        await createVeiculo(
          marca,
          modelo,
          ano,
          valor,
          quilometragem,
        );

        mensagem('Veiculo Cadastrado com Sucesso!');
      } else {
        mensagem('Informações Inválidas!');
      }

      print('Pressione ENTER para continuar...');
      stdin.readLineSync();
      limparTela();
 
    } else if (index == 1) {
      mensagem('Veiculos Cadastrados');

      await readVeiculo();

      print('\nPressione ENTER para continuar...');
      stdin.readLineSync();
      limparTela();

    } else if (index == 2) {
      mensagem('Atualizar Veiculo');

      final veiculos = await supabase
          .from('veiculo')
          .select();

      if (veiculos.isEmpty) {
        mensagem('Nenhum Veiculo Cadastrado!');
        stdin.readLineSync();
        continue;
      }

      List<String> opcoesVeiculosEditar = [];

      for (final veiculo in veiculos) {
        opcoesVeiculosEditar.add(
          'ID: ${veiculo['id']} | ${veiculo['marca']} ${veiculo['modelo']} | ${formatarValor(veiculo['valor'])} | ${veiculo['quilometragem']} km'
        );
      }

      final indexOpcaoVeiculo = Select(
        prompt: 'Selecione o veículo para editar:',
        options: opcoesVeiculosEditar,
      ).interact();

      final idVeiculo = veiculos[indexOpcaoVeiculo]['id'];

      print('\nNova marca:');
      String marca = stdin.readLineSync()!;

      print('Novo modelo:');
      String modelo = stdin.readLineSync()!;

      print('Novo ano:');
      int ano = int.parse(stdin.readLineSync()!);

      print('Novo valor (R\$):');
      double valor = double.parse(stdin.readLineSync()!);

      print('Nova quilometragem (km):');
      int quilometragem = int.parse(stdin.readLineSync()!);

      if (marca.trim().isNotEmpty &&
          modelo.trim().isNotEmpty &&
          ano >= 1900 &&
          valor > 0 &&
          valor < 10000000000 &&
          quilometragem >= 0) {

        final confirmacao = Select(
          prompt: 'Deseja confirmar a atualização?',
          options: ['Sim', 'Não'],
        ).interact();

        if (confirmacao == 0) {
          await updateVeiculo(
            idVeiculo,
            marca,
            modelo,
            ano,
            valor,
            quilometragem,
          );

          mensagem('Veiculo Atualizado com Sucesso!');
        } else {
          mensagem('Atualização Cancelada!');
        }
      } else {
        mensagem('Informações Inválidas!');
      }

      print('Pressione ENTER para continuar...');
      stdin.readLineSync();
      limparTela();

    } else if (index == 3) {
      mensagem('Excluir Veiculo');

      final veiculos = await supabase
          .from('veiculo')
          .select();

      if (veiculos.isEmpty) {
        mensagem('Nenhum Veiculo Cadatrado!');
        stdin.readLineSync();
        continue;
      }

      List<String> opcoesVeiculos = [];

      for (final veiculo in veiculos) {
        opcoesVeiculos.add(
          'ID: ${veiculo['id']} | ${veiculo['marca']} ${veiculo['modelo']} | ${formatarValor(veiculo['valor'])} | ${veiculo['quilometragem']} km'
        );
      }

      final indexOpcaoVeiculo = Select(
        prompt: 'Selecione o veículo para excluir:',
        options: opcoesVeiculos,
      ).interact();

      final idVeiculo = veiculos[indexOpcaoVeiculo]['id'];

      final confirmacao = Select(
        prompt: 'Tem certeza que deseja excluir?',
        options: ['Sim', 'Não'],
      ).interact();

      if (confirmacao == 0) {
        await deleteVeiculo(idVeiculo);
        mensagem('Veiculo Excluido com Sucesso!');
      } else {
        mensagem('Exclusao Cancelada!');
      }

      print('Pressione ENTER para continuar...');
      stdin.readLineSync();
      limparTela();

    } else if (index == 4) {
      mensagem('Encerrando Sistema...');
      print('Obrigado por utilizar a Agência Willians!');
      await supabase.dispose();
      break;
    }
  }
}
