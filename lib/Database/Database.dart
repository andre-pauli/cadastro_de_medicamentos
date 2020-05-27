//INCLUINDO AS BIBLIOTECAS NECESSÁRIAS PARA O FUNCIONAMENTO DO APP
import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:cadastrodemedicamentos/Models/Medicamento.dart';

//DEFININDO A CLASSE DE ACESSO AO BANCO DE DADOS
class DatabaseClass{


  static DatabaseClass _databaseClass;
  static Database _database;

  //O CÓDGIO ABAIXO GARANTE QUE A CLASSE SEJA SINGLETON OU SEJA, POSSUA
  //APENAS UMA INSTÂNCIA NO APP.
  DatabaseClass._createInstance();
  factory DatabaseClass(){
    if(_databaseClass == null){
      _databaseClass = DatabaseClass._createInstance();
    }
    return _databaseClass;
  }

  //FUNÇÃO UTILIZADA PARA PEGAR O ACESSO AO BANCO
  //CASO JÁ ESTEJA CRIADO, ELE RETORNA, SENÃO ELE CRIA UMA NOVA CONEXÃO
  Future<Database> get database async{
    if(_database == null){

      //pega o caminho do banco de dados
      Directory dir = await getApplicationDocumentsDirectory();
      String path = dir.path + "/medicamentos.db";

      //abre conexão com o banco
      _database = await openDatabase(path, version: 1, onCreate: (Database db, int newVersion) async{
        await db.execute(
            'CREATE TABLE medicamento('
                'id INTEGER PRIMARY KEY AUTOINCREMENT,'
                'nome TEXT,'
                'descricao TEXT,'
                'valor TEXT)'
        );
      });
    }

    return _database;
  }

  //FUNÇÃO QUE RECEBE UM OBJETO DO TIPO MEDICAMENTO E FAZ A INCLUSÃO DO MESMO NO DB.
  Future<int> cadastraMedicamento(Medicamento medicamento) async{

    //recebe a instância do banco
    Database db = await this.database;

    //inclui o medicamento no banco
    var resultado = await db.rawInsert(
        'INSERT INTO medicamento(nome, descricao, valor) VALUES(?, ?, ?)',
        [medicamento.nome, medicamento.descricao, medicamento.valor]);
    return resultado;
  }

  //FUNÇÃO QUE RECEBE O ID DE UM MEDICAMENTO E DELETA O REGISTRO DO BANCO
  Future<int> excluiMedicamento(int id) async{
    var db = await this.database;

    //apaga o registro do banco no qual o id seja igual ao que a função recebeu
    int resultado = await db.delete('medicamento',
        where: "id = ?",
        whereArgs: [id]);
    return resultado;
  }

  //FUNÇÃO UTILIZADA PARA BUSCAR TODOS OS REGISTRO DO BANCO DE DADOS
  Future<List<Medicamento>> buscaMedicamentos() async{
    Database db = await this.database;

    //o método query representa um select*from medicamento, ele pega todos os regístros de uma tabela
    var resultado = await db.query('medicamento');

    //verifica se a lista não está vazia e caso não tiver ele converte o map regístros em uma Lista de
    //medicamentos
    List<Medicamento> lista = resultado.isNotEmpty? resultado.map((m)=> Medicamento.fromMap(m)).toList() : [];
    return lista;
  }
}