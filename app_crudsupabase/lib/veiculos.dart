import 'conexao.dart';

Future createVeiculo(String marca,String modelo,int ano, double valor,int quilometragem) async {
     final supabase = conexao();
  try{
    final veiculo = await supabase
    .from('veiculo')
    .insert({
      'marca' : marca,
      'modelo': modelo,
      'ano' : ano,
      'valor': valor,
      'quilometragem' : quilometragem
    })
    .select()
    .single();
    print(veiculo);
        print("Veículo criado com sucesso!");
  } catch(erro){
    print("Ocorreu o seguinte erro $erro");
  } finally{
    //encerra a conexao
    await supabase.dispose();
  }
  }

Future deleteVeiculo(int idVeiculo) async {
  final supabase = conexao();

  try {
   
    final veiculo = await supabase
        .from("veiculo")
        .delete()
        .eq("id", idVeiculo)
        .select()
        .single();

    print(veiculo);
    print("Veículo excluído com sucesso!");

  } catch (erro) {
    print(erro);
  } finally {
    await supabase.dispose();
  }

}


Future<void> readVeiculo() async {
  final supabase = conexao();

  try {
    final veiculos = await supabase
        .from('veiculo')
        .select()
        .order('id');

    if (veiculos.isEmpty) {
      print('''
+----------------------------------------------------------------+
                  Nenhum veículo cadastrado!
+----------------------------------------------------------------+
      ''');
      return;
    }



    for (final veiculo in veiculos) {
      final valor = double.parse(
        veiculo['valor'].toString(),
      ).toStringAsFixed(2);

      print('''
+---------------------------------------------------------+
      ID: ${veiculo['id']}                                   
      Marca: ${veiculo['marca']}                             
      Modelo: ${veiculo['modelo']}                           
      Ano: ${veiculo['ano']}                                  
      Valor: R\$ $valor                                      
      Quilometragem: ${veiculo['quilometragem']} km           
+---------------------------------------------------------+
''');
    }
  } catch (erro) {
    print('\nErro ao listar veículos: $erro');
  } finally {
    await supabase.dispose();
  }
}


Future updateVeiculo(int idVeiculo,String marca,String modelo,int ano, double valor,int quilometragem) async{
  final supabase = conexao();

  try{
    
    final veiculo = await supabase
    //infromar a tabela
    .from("veiculo")
    //metodo para atualizar
    .update({
      'marca' : marca,
      'modelo': modelo,
      'ano' : ano,
      'valor': valor,
      'quilometragem' : quilometragem
    })
    //identificador
    .eq("id", idVeiculo)
    //retornar os valores atualizados
    .select()
    .single();

    print(veiculo);
    print("Atualização feita com Sucesso");
    
  }catch(erro){
    print(erro);
  }finally{
    await supabase.dispose();
  }
}