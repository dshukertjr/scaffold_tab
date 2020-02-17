# tab_scaffold

Widget that will create `Scaffold` ios like tab navigation.

## Installation

See [instructions](https://pub.dev/packages/tab_scaffold#-readme-tab-) on how to install.

## Usage

```dart
    ScaffoldTab(
      tabIndex: _tabIndex
      pages: <Widget>[
        Center(child: Icon(Icons.home)),
        Center(child: Icon(Icons.train)),
      ],
      bottomNavigationBar: BottomAppBar(
        child: Builder(builder: (context) {
          return Row(
            children: <Widget>[
              FlatButton(
                child: Text('snack bar'),
                onPressed: () {
                  Scaffold.of(context).showSnackBar(SnackBar(
                    content: Text('Hello World!'),
                  ));
                },
              ),
              IconButton(
                icon: Icon(Icons.train),
                onPressed: () {
                  ScaffoldTab.of(context).openTab(1);
                },
              ),
            ],
          );
        }),
      ),
    );
```

Pass a tabIndex to `ScaffoldTab` widget to specify the currently active index.

`ScaffoldTab` also creates a `Scaffold` widget within, so Scaffold.of
method is available for `ScaffoldTab` widget's descendent.
