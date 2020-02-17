# tab_scaffold

Widget that will create `Scaffold` ios like tab navigation.

## Installation

See [instructions](https://pub.dev/packages/tab_scaffold#-readme-tab-) on how to install.

## Usage

### The Old Way

When creating a `Scaffold` that uses a `BottomNavigationBar`, it's not
uncommon to end up with code like this:

```dart
    ScaffoldTab(
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

`ScaffoldTab` widget has openTab and openPreviousTab methods.
openTab methods takes one int argument index, which is the index of the tab
to be opened.
openPreviousTab will go back to the previously opened tab if there are any.

`ScaffoldTab` also creates a `Scaffold` widget within, so Scaffold.of
method is available for `ScaffoldTab` widget's descendent.
