import 'package:cadastrodemedicamentos/Database/Database.dart';
import 'package:cadastrodemedicamentos/Models/Medicamento.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

//COMPONENTE ESTÁTICO DA TELA, REPONSÁVEL POR CRIAR O ESCOPO PRINCIPAL DO APP
class MyApp extends StatelessWidget {
  String _title = 'Cadastro de medicamentos';

  //O MÉTODO BUILD FAZ A COMPILAÇÃO PARA QUE SEJA
  //EXIBIDO ALGO NA TELA
  @override
  Widget build(BuildContext context) {
    //MATERIAAPP É UM WIDGET QUE AGRUPOS OUTROS WIGETS, GERALMENTE ESSENCIAS PARA O MATERIAL DESIGN
    return MaterialApp(
      title: _title,
      //THEMEDATA É RESPONSÁVEL PELO TEMA PADRÃO DO APP
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      //HOME É O CONTEÚDO QUE É EXIBIDO NA TELA,
      //E NESSE CASO ESTÁ CHAMANDO OUTRO WIDGET
      home: MyHomePage(title: _title),
    );
  }
}

//COMPONENTE DINÂMICO DE TELA, REPONSÁVEL POR CRIAR A LISTA DE EXIBIÇÃO DE MEDICAMENTOS
class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {

    //O SCAFFOLD IMPLEMENTA A ESTRUTURA BÁSICA DE UMA LAYOUT, GERALMENTE DE ACORDO COM O METERIAL DESIGN
    return Scaffold(
      //APPBAR É A BARRA SUPERIOR, ONDE PODE CONTER O TÍTULO DA PÁGINA POR EXEMPLO.
      appBar: AppBar(
        title: Text(widget.title),
      ),
      //CENTER É RESPONSÁVEL POR DEIXAR TODOS OS SEUS WIDGETS FILHOS ALINHADOS NO CENTRO DA TELA OU DO COMPONENTE EM QUE
      //ELE ESTEJA
      body: Center(
        //COLUMN POSSIBILITA AGRUPAR VÁRIOS WIDGETS NA VERTICAL
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          //LISTAGEM DOS WIDGETS FILHOS DA COLUNA
          children: <Widget>[
            //BOTÃO
            RaisedButton(
              child: Text("Novo Medicamento"),
              onPressed: (){
                //FUNÇÃO DE NAVEGAÇÃO DENTRO DO FLUTTER, AO CLICAR NO BOTÃO
                //O USUÁRIO SERÁ DIRECIONADO PARA O FORMULÁRIO.
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Formulario(title: widget.title)),
                );
              },
            ),
            //DIVISOR DE TELA
            Divider(color: Colors.transparent,),
            Divider(color: Colors.transparent,),
            RaisedButton(
              child: Text("Medicamentos"),
              onPressed: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ListaMedicamentos(title: widget.title,)),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}

//COMPONENTE DINÂMICO DE TELA, REPONSÁVEL POR CRIAR O FORMULÁRIO DE INCLUSÃO
class Formulario extends StatefulWidget {
  Formulario({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _FormularioState createState() => _FormularioState();
}

class _FormularioState extends State<Formulario> {

  //INSTÂNCIANDO A CLASSE DE ACESSO AO BANCO DE DADOS
  DatabaseClass db = DatabaseClass();

  //CRIANDO OS CONTROLADORES DOS CAMPOS, PARA ACESSAR
  //O QUE O USUÁRIO DIGITOU EM CASA CAMPO
  TextEditingController _nomeMed = TextEditingController();
  TextEditingController _descricaoMed = TextEditingController();
  TextEditingController _valorMed = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: new Column(
        children: <Widget>[
          Divider(
            color: Colors.transparent,
          ),
          //LISTTILE É UM BLOCO DE LISTA, QUE PODE AGRUPAR ATÉ 3 LINHAS DE TEXTO OPCIONAIS, PODENDO
          //TAMBÉM ADICIONAR ÍCONES, QUE É ESSE CASO.
          new ListTile(
            //TEXTFILD É O COMPONENTE DE INPUT DE TEXTO, NELE QUE O USUÁRIO DIGITARÁ O QUE DESEJA
            title: new TextField(
              //AQUI DIZEMOS QUE NOSSO CONTROLADOR IRÁ CONTROLAR ESSE INPUT
              controller: _nomeMed,
              decoration: new InputDecoration(
                hintText: "Nome do Medicamento",
              ),
            ),
          ),
          new ListTile(
            title: new TextField(
              controller: _descricaoMed,
              decoration: new InputDecoration(
                hintText: "Descrição",
              ),
            ),
          ),
          new ListTile(
            title: new TextField(
              keyboardType: TextInputType.number,
              controller: _valorMed,
              decoration: new InputDecoration(
                hintText: "Valor",
              ),
            ),
          ),
          Divider(
            color: Colors.transparent,
          ),
          RaisedButton(
            child: Text(
              "Salvar",
              style: TextStyle(color: Colors.white),
            ),
            color: Colors.blue,
            onPressed: () {
              //INSTÂNCIANDO UM NOVO MEDICAMENTO COM OS DADOS QUE O USUÁRIO DIGITAR NO FORMULÁRIO
              Medicamento medicamento = Medicamento(
                  nome: _nomeMed.text,
                  descricao: _descricaoMed.text,
                  valor: _valorMed.text);
              //ACESSA A FUNÇÃO DE CADASTRAR UM NOVO MEDICAMENTO, PASSANDO O MEDICAMENTO.
              db.cadastraMedicamento(medicamento);

              //VOLTANDO PARA A TELA QUE CHAMOU O FORMULÁRIO
              Navigator.pop(context);
            },
          )
        ],
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

//COMPONENTE DINÂMICO DE TELA, REPONSÁVEL POR CRIAR A LISTA DE MEDICAMENTOS
class ListaMedicamentos extends StatefulWidget {
  ListaMedicamentos({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _ListaMedicamentosState createState() => _ListaMedicamentosState();
}

class _ListaMedicamentosState extends State<ListaMedicamentos> {

  //INSTÂNCIANDO A CLASSE DE ACESSO AO BANCO DE DADOS
  DatabaseClass db = DatabaseClass();

  //CRIANDO UMA LISTA DE MEDICAMENTOS
  List<Medicamento> medicamentos = List<Medicamento>();

  //MÉTODO QUE SERÁ EXECUTADO AO ACESSAR ESSA PÁGINA
  @override
  void initState() {
    super.initState();

    //FAZENDO A CHAMADA DO MÉTODO DE BUSCA DA CLASSE DO BANCO
    db.buscaMedicamentos().then((lista) {
      //O SETSTATE É UTILIZADO PARA ATUALIZAR OS DADOS EM TEMPO DE EXECUÇÃO, OU
      //SEJA, MUDAR UM COMPONENTE QUE ESTÁ SENDO EXIBIDO NA TELA
      setState(() {
        //INCLUINDO A LISTA QUE RETORNOU DO BANCO, NA NOSSA LISTA DE MEDICAMENTOS
        medicamentos = lista;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      //FAZ UMA VERIFICAÇÃO
      //CASO A LISTA ESTEJA VAZIA ELE EXIBE UMA MENSAGEM PRO USUÁRIO
      //SE NÃO ESTIVER, ELE EXIBE A LISTA
      body: medicamentos.isEmpty ? Center(child: Text("Nenhum medicamento cadastrado"),):
      //COMPONENTE QUE PERCORRE TODA A LISTA E EXIBE CADA REGÍSTRO
      ListView.builder(
        padding: EdgeInsets.all(10),
        itemCount: medicamentos.length,
        itemBuilder: (context, index) {
          //CARD É UM COMPONENTE DE EMBELEZAMENTO QUE AGRUPO FILHOS DENTRO DELE
          //E OS EXIBE EM FORMA DE UM CARTÃO
          return Card(
              child: ListTile(
                //TEM A MESMA FUNÇÃO DA COLUMN, PORÉM AGRUPA OS WIDGETS NA HORIZONTAL
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          //PADDIGN É UM COMPONETE QUE INCLUI UM ESPAÇO EM VOLTA DO COMPONENTE
                          Padding(
                            padding: EdgeInsets.all(5),
                            //O INDEX É CADA POSIÇÃO DA NOSSA LISTA
                            child: Text(medicamentos[index].nome),
                          ),
                          Padding(
                            padding: EdgeInsets.all(5),
                            child: Text(medicamentos[index].descricao),
                          ),
                          Padding(
                            padding: EdgeInsets.all(5),
                            child: Text('R\$ '+medicamentos[index].valor),
                          ),
                        ],
                      ),
                      //ICONBUTTON É UM ÍCONE QUE PODE DISPARAR UMA AÇÃO
                      //QUE NESSE CASO ESTÁ DISPARANDO A AÇÃO DE APAGAR UM MEDICAMENTO
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                title: const Text('Deseja realmente excluir o medicamento?'),
                                actions: <Widget>[
                                  new FlatButton(
                                    onPressed: () {
                                      //CHAMA A FUNÇÃO DE EXCLUSÃO DA CLASSE DO BANCO
                                      db.excluiMedicamento(medicamentos[index].id);
                                      //ATUALIZA A LISTA NOVAMENTE
                                      db.buscaMedicamentos().then((lista) {
                                        setState(() {
                                          medicamentos = lista;
                                        });
                                      });
                                      Navigator.of(context).pop();
                                    },
                                    child: Text("Sim"),
                                  ),
                                  new FlatButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text("Não"),
                                  ),
                                ],
                              ));
                        },
                      )
                    ],
                  )));
        },
      ),
    );
  }
}

