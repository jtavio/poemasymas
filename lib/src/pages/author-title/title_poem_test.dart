import 'package:app_poemas/src/bloc/blocs.dart';
import 'package:app_poemas/src/pages/author-title/author_title_poems.dart';
import 'dart:io' show Platform, exit;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_plus/share_plus.dart';

class TitlePoemByAuthor extends StatefulWidget {
  static const routeName = '/titlepoem';
  final String title;
  const TitlePoemByAuthor({this.title = ''});

  @override
  State<TitlePoemByAuthor> createState() => _TitlePoemByAuthorState();
}

class _TitlePoemByAuthorState extends State<TitlePoemByAuthor> {
  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: new Text('Are you sure?'),
            content: new Text('Do you want to exit an App'),
            actions: <Widget>[
              TextButton(
                onPressed: () =>
                    Navigator.of(context).pop(false), //<-- SEE HERE
                child: new Text('No'),
              ),
              TextButton(
                onPressed: () {
                  if (Platform.isAndroid) {
                    SystemNavigator.pop();
                  } else if (Platform.isIOS) {
                    exit(0);
                  }
                },
                child: new Text('Yes'),
              ),
            ],
          ),
        )) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: Stack(
          children: [
            _MainScroll(widget.title),
            Positioned(bottom: 30, right: 10, child: _BotonShared())
          ],
        ),
      ),
    );
  }
}

class _BotonShared extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconButton(
        icon: const Icon(
          Icons.share_outlined,
          color: Colors.white,
          size: 35.0,
        ),
        tooltip: 'shared',
        onPressed: () async {
          String result = '';
          final nameTitle =
              BlocProvider.of<AuthorTitleBloc>(context).state.titlePoem;
          for (final elem in nameTitle) {
            final texto = elem.lines;

            result = texto.join('');
            print('${elem.author}');

            await Share.share(
                'Title: ${elem.title}\nAuthor: ${elem.author}\n$result',
                subject: 'Title: ${elem.author}');
          }
        });
  }
}

class _MainScroll extends StatelessWidget {
  String title;
  _MainScroll(this.title);

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        // SliverAppBar(
        //   floating: true,
        //   elevation: 0,
        //   backgroundColor: Colors.red,
        //   title: Text('Hola Mundo'),
        // ),
        SliverPersistentHeader(
            floating: true,
            delegate: _SliverCustomHeaderDelegate(
                minheight: 170,
                maxheight: 200,
                child: Container(
                  alignment: Alignment.centerLeft,
                  color: Colors.deepOrangeAccent[100],
                  child: _Titulo(title),
                ))),
        SliverList(
          delegate: SliverChildListDelegate(
            [
              BlocBuilder<AuthorTitleBloc, AuthorTitleState>(
                builder: (context, state) {
                  if (state.titlePoem.isNotEmpty) {
                    final linesArr = state.titlePoem[0].lines.length;
                    final showLines = state.titlePoem[0].lines;
                    return ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: linesArr,
                      itemBuilder: (context, index) {
                        return Center(
                            child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            showLines[index],
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ));
                      },
                    );
                  }
                  if (state.error != null) {
                    return Center(
                      child: Text(state.error!['message']),
                    );
                  }
                  return const Padding(
                    padding: EdgeInsets.only(top: 20.0),
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                },
              ),
              const SizedBox(),
            ],
          ),
        )
      ],
    );
  }
}

class _SliverCustomHeaderDelegate extends SliverPersistentHeaderDelegate {
  final double minheight;
  final double maxheight;
  final Widget child;

  _SliverCustomHeaderDelegate(
      {required this.minheight, required this.maxheight, required this.child});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(child: child);
  }

  @override
  double get maxExtent => maxheight;

  @override
  double get minExtent => minheight;

  @override
  bool shouldRebuild(_SliverCustomHeaderDelegate oldDelegate) {
    return maxheight != oldDelegate.maxheight ||
        minheight != oldDelegate.minheight ||
        child != oldDelegate.child;
  }
}

class _Titulo extends StatelessWidget {
  String title;
  _Titulo(this.title);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              BlocProvider.of<AuthorTitleBloc>(context, listen: false)
                  .add(const DeleteStatePoemByAuthor([]));
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => AuthorTitle(),
                ),
              );
            }),
        Flexible(
          child: Padding(
            padding: const EdgeInsets.only(left: 35, right: 25),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 5,
                ),
                Text(
                  title,
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}
