import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FormPage extends StatefulWidget {
  
  FormPage({this.document});
  
  DocumentSnapshot document;

  @override
  _FormPageState createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {


  final _titleController = TextEditingController();
  final _subtitleController = TextEditingController();
  final _textController = TextEditingController();
  
  final _subtitleFocusNode = FocusNode();
  final _textFocusNode = FocusNode();

  ScrollController _scrollController;
  bool lastStatus = true;
  bool isShrink = false;

  @override
  void initState() {
    super.initState();

    _titleController.text = widget.document['title'];
    _subtitleController.text = widget.document['subtitle'];
    _textController.text = widget.document['body'];

    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.document == null ? "Novo Post" : widget.document['title']),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: <Widget>[
          widget.document == null 
            ? Text("") 
            : IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                widget.document.reference.delete();
                Navigator.of(context).pop();
              },
            )
        ],
      ),
      // body: ListView(
      //   children: <Widget>[
      //     _widgetEmail(),
      //     _widgetSubtitle(),
      //     _widgetText()
      //   ],
      // ),
      body: NestedScrollView(
        controller: _scrollController,
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              expandedHeight: 200.0,
              floating: false,
              pinned: true,
              backgroundColor: Theme.of(context).backgroundColor,
              iconTheme: IconThemeData(
                color: isShrink ? Theme.of(context).textTheme.subtitle.color : Colors.white,
              ),
              elevation: 0,
              flexibleSpace: LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
                return FlexibleSpaceBar(    
                  title: Text(
                    widget.document == null ? "Novo Post" : widget.document['title'], 
                    style: TextStyle(
                      fontSize: 20,
                      color: isShrink ? Theme.of(context).textTheme.subtitle.color : Colors.white,
                    )
                  ),
                  background: CachedNetworkImage(
                      imageUrl: widget.document['image'],
                      imageBuilder: (context, imageProvider) => Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.cover
                          ),
                        ),
                      ),
                      placeholder: (context, url) => new CircularProgressIndicator(),
                      errorWidget: (context, url, error) => new Icon(Icons.error),
                  )
                );
              })
            ),
          ];
        },
        // body: ,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          
          var obj = {
            'title': _titleController.text,
            'subtitle':  _subtitleController.text,
            'body': _textController.text
          };
          
          widget.document.reference.updateData(obj);
        },
        child: Icon(Icons.save),
      ),
    );
  }

  _widgetEmail() {
    return Padding(
      padding: EdgeInsets.only(top: 50, left: 20, right: 20, bottom: 10),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(20.0)),
        elevation: 10,
        child: TextFormField(
          controller: _titleController,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          onFieldSubmitted: (text) {
            FocusScope.of(context).requestFocus(_subtitleFocusNode);
          },
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
              borderSide: BorderSide.none,
            ),
            hintStyle: TextStyle(
              color: Colors.grey,
              fontSize: 15
            ),
            labelText: "Titulo"
          ),
        ),
      ),
    );
  }

  _widgetSubtitle() {
    return Padding(
      padding: EdgeInsets.only(top: 50, left: 20, right: 20, bottom: 10),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(20.0)),
        elevation: 10,
        child: TextFormField(
          controller: _subtitleController,
          focusNode: _subtitleFocusNode,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          onFieldSubmitted: (text) {
            FocusScope.of(context).requestFocus(_textFocusNode);
          },
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
              borderSide: BorderSide.none,
            ),
            hintStyle: TextStyle(
              color: Colors.grey,
              fontSize: 15
            ),
            labelText: "Subtitle"
          ),
        ),
      ),
    );
  }

  _widgetText() {
    return Padding(
      padding: EdgeInsets.only(top: 50, left: 20, right: 20, bottom: 10),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(20.0)),
        elevation: 10,
        child: TextFormField(
          controller: _textController,
          focusNode: _textFocusNode,
          keyboardType: TextInputType.multiline,
          textInputAction: TextInputAction.newline,
          minLines: 5,
          maxLines: 15,
          onFieldSubmitted: (text) {
            FocusScope.of(context).requestFocus(_textFocusNode);
          },
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
              borderSide: BorderSide.none,
            ),
            hintStyle: TextStyle(
              color: Colors.grey,
              fontSize: 15
            ),
            labelText: "Text"
          ),
        ),
      ),
    );
  }

  _scrollListener() {
    if (isShrink != lastStatus) {
      setState(() {
        lastStatus = isShrink;
      });
    }
  }
}