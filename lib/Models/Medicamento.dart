//DEFININDO A CLASSE MEDICAMENTO
class Medicamento {

  //PROPRIEDADES DO MEDICAMENTO
  int id;
  String nome;
  String descricao;
  String valor;

  //CONSTRUTOR DA CLASSE
  Medicamento({this.id, this.nome, this.descricao, this.valor});

  //FUNÇÃO PARA CONVERTER UM OBJETO PARA MAP
  Map<String, dynamic>toMap(){
    var map = <String, dynamic>{
      'id': id,
      'nome': nome,
      'descricao': descricao,
      'valor': valor
    };
  }

  //FUNÇÃO PARA CONVERTER UM MAP EM UM OBJETO DO TIPO MEDICAMENTO
  Medicamento.fromMap(Map<String, dynamic> map){
    id = map['id'];
    nome = map['nome'];
    descricao = map['descricao'];
    valor = map['valor'];

  }
}