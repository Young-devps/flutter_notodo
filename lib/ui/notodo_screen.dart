import 'package:flutter/material.dart';
import 'package:sqflite_intro/utils/date_formatter.dart';
import '../models/nodo_item.dart';
import '../utils/database_client.dart';


class NotodoScreen extends StatefulWidget {
  @override
  _NotodoScreenState createState() => _NotodoScreenState();
}

class _NotodoScreenState extends State<NotodoScreen> {



  final TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,

      body: Column(
        children: <Widget>[
          Flexible(
            child: ListView.builder(
                padding: EdgeInsets.all(8.0),
                reverse: false,
                itemCount: _itemList.length,
                itemBuilder: (_, int index){
                  return new Card(
                    color: Colors.white70,
                    child: new ListTile(
                      title: _itemList[index],
                      onLongPress: () => _updateItem(_itemList[index], index),
                      trailing: new Listener(
                        key: new Key(_itemList[index].itemName),
                        child: new Icon(Icons.remove_circle, color: Colors.redAccent,),
                        onPointerDown: (pointerEvent) => _deleteNoDo(_itemList[index].id, index),
                      ),
                    ),
                  );
                }
            ),
          ),

          new Divider(
            height: 1.0,
          )
        ],
      ),

      floatingActionButton: FloatingActionButton(
          tooltip: "Add Item",
          backgroundColor: Colors.orange,
          child: ListTile(
            title: Icon(Icons.add),
          ),
          onPressed: _showFormDialog
      ),
    );
  }

  void _showFormDialog(){
    var alert = AlertDialog(
      content: new Row(
        children: <Widget>[
          new Expanded(child: new TextField(
            controller: _textEditingController,
            autofocus: true,
            decoration: new InputDecoration(
              labelText: "Item",
              hintText: "eg. dont't buy stuff",
              icon: Icon(Icons.note_add)
            ),
          ))
        ],
      ),

      actions: <Widget>[
        new FlatButton(
          onPressed: () {
            _handleSubmitted(_textEditingController.text);
            _textEditingController.clear();
            },
          child: Text("save")),
        new FlatButton(
          onPressed: () => Navigator.pop(context),
          child: Text("cancel"))
      ],
    );
    showDialog( context: context, builder:(_){return alert;} );
  }

  var db = new DatabaseHelper();
  final List<NodoItem> _itemList = <NodoItem>[];

  void _handleSubmitted(String text) async {
    _textEditingController.clear();
    NodoItem noDoItem = new NodoItem(text, dateFormatted());
    int saveItemId = await db.saveItem(noDoItem);

    NodoItem addedItem = await db.getItem(saveItemId);

    setState((){
      _itemList.insert(0, addedItem);
    });

    print("Item saved id: $saveItemId");
  }

  _readNodoList() async {
    List items = await db.getItems();
    items.forEach((item){
      NodoItem noDoItem = NodoItem.map(item);
      print("Db items : ${noDoItem.itemName}");
    });
  }

  @override
  void initState() {
    super.initState();
    _readNodoList();
  }

  _deleteNoDo(int id, int index) async{
    debugPrint("Delete item");
    await db.deleteItem(id);
    setState(() {
      _itemList.removeAt(index);
    });
  }

  _updateItem(NodoItem item, int index) {
    var alert = new AlertDialog(
      title: new Text("Update Item"),
      content: new Row(
        children: <Widget>[
          new Expanded(
              child: new TextField(
                controller: _textEditingController,
                autofocus: true,
                autocorrect: true,
                decoration: new InputDecoration(
                  labelText: "Item",
                  hintText: "eg. buy stuff",
                  icon: Icon(Icons.update)
                ),
              )
          )
        ],
      ),

      actions: <Widget>[
        new FlatButton(
          onPressed: () async{
            NodoItem newItemUpdated = NodoItem.fromMap(
              {
                "itemName"   : _textEditingController.text,
                "dateCreated": dateFormatted(),
                "item"       : item.id
              }
            );
            _handleSummittedUpdate(index, item); //redrawing he screen
            await db.updatItem(newItemUpdated); //updating the item
            setState(() {
              _readNodoList(); //redrawing the screen with all the irems save in the db
            });

            Navigator.pop(context);
          },

          child: new Text("update"),
        ),

        new FlatButton(
          onPressed: () => Navigator.pop(context),
          child: new Text("cancel"),
        )
      ],
    );
    showDialog(
      context: context, builder: (_){
        return alert;
    }
    );
  }

  void _handleSummittedUpdate(int index, NodoItem item) {
    _itemList.removeWhere((element){
      _itemList[index].itemName == item.itemName;
    });
  }

}
