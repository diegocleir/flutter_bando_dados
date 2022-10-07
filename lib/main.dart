import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

void main() {
  runApp(MaterialApp(
    home: Home(),
  ));
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  _recuperarBancoDados() async {

    final caminhoBancoDados = await getDatabasesPath();
    final localBancoDados = join(caminhoBancoDados, "banco.db");

    var bd = await openDatabase(
      localBancoDados,
      version: 1,
      onCreate: (db, dbVersaoRecente){
        String sql = "CREATE TABLE usuarios (id INTEGER PRIMARY KEY AUTOINCREMENT, nome VARCHAR, idade INTEGER) ";
        db.execute(sql);
      }
    );

    return bd;
    //print("aberto: " + bd.isOpen.toString() );

  }

  _salvar() async {

    Database bd = await _recuperarBancoDados();

    Map<String, dynamic> dadosUsuario = {
      "nome": "Justina Lamistiano",
      "idade": 65
    };
    int id = await bd.insert("usuarios", dadosUsuario);
    print("Salvo: ${id.toString()} ");
  }

  _listarUsuarios() async {
    Database bd = await _recuperarBancoDados();

    String query = "select * from usuarios order by UPPER(nome) ASC";
    List usuarios = await bd.rawQuery(query);

    for( var usuario in usuarios ){
      print(
        "item id: " + usuario["id"].toString() +
          " nome: " + usuario["nome"] +
            " idade: " + usuario["idade"].toString()
      );
    }

    //print("usuarios: " + usuarios.toString() );

  }

  _listarUsuarioPorId(int id) async {

    Database bd = await _recuperarBancoDados();

    List usuarios = await bd.query(
        "usuarios",
        where: "id = ?",
        whereArgs: [id]
    );

    for( var usuario in usuarios ){
      print(
          "item id: " + usuario["id"].toString() +
              " nome: " + usuario["nome"] +
              " idade: " + usuario["idade"].toString()
      );
    }

  }

  _excluirUsuario(int id) async {

    Database bd = await _recuperarBancoDados();

    int retorno = await bd.delete(
        "usuarios",
        where: "id = ?",
        whereArgs: [id]
    );

    print("item qtde removida: " + retorno.toString());

  }

  _atualizarUsuario(int id) async {

    Database bd = await _recuperarBancoDados();

    Map<String, dynamic> dadosUsuario = {
      "nome": "Diego Alves alterado",
      "idade": 1
    };
    int retorno = await bd.update(
        "usuarios",
        where: 'id=?',
        whereArgs: [id],
        dadosUsuario
    );

    print("item qtde atualizada: " + retorno.toString());

  }


  @override
  Widget build(BuildContext context) {

    _salvar();
    //_excluirUsuario(2);
    //_atualizarUsuario(1);
    _listarUsuarios();
    //_listarUsuarioPorId(1);

    return Container();
  }
}
