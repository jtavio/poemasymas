import 'package:app_poemas/src/bloc/blocs.dart';
import 'package:app_poemas/src/models/data_firestore.dart';
import 'package:app_poemas/src/pages/author-title/author_title_poems.dart';
import 'dart:io' show Platform, exit;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_plus/share_plus.dart';

class TitlePoemByAuthor extends StatefulWidget {
  static const routeName = '/titlepoem';

  @override
  State<TitlePoemByAuthor> createState() => _TitlePoemByAuthorState();
}

class _TitlePoemByAuthorState extends State<TitlePoemByAuthor> {
  Author? title;
  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Are you sure?'),
            content: const Text('Do you want to exit an App'),
            actions: <Widget>[
              TextButton(
                onPressed: () =>
                    Navigator.of(context).pop(false), //<-- SEE HERE
                child: const Text('No'),
              ),
              TextButton(
                onPressed: () {
                  if (Platform.isAndroid) {
                    SystemNavigator.pop();
                  } else if (Platform.isIOS) {
                    exit(0);
                  }
                },
                child: const Text('Yes'),
              ),
            ],
          ),
        )) ??
        false;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    title = BlocProvider.of<AuthorTitleBloc>(context).state.author!;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: Stack(
          children: [
            _MainScroll(title),
            Positioned(bottom: 30, right: 10, child: _BotonShared(title))
          ],
        ),
      ),
    );
  }
}

class _BotonShared extends StatelessWidget {
  Author? title;
  _BotonShared(this.title);

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
          // final nameTitle =
          //     BlocProvider.of<AuthorTitleBloc>(context).state.titlePoem;
          // for (final elem in nameTitle) {
          //   final texto = elem.lines;

          //   result = texto.join('');
          //   print('${elem.author}');

          await Share.share(
              'Title: ${title!.title}\n${title!.lineas!.join(' ')}',
              subject: 'Title: ${title!.author}');
        });
  }
}

class _MainScroll extends StatelessWidget {
  Author? value;
  _MainScroll(this.value);

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
                  child: _Titulo(value),
                ))),
        SliverList(
          delegate: SliverChildListDelegate(
            [
              BlocBuilder<AuthorTitleBloc, AuthorTitleState>(
                builder: (context, state) {
                  if (state.author != null) {
                    return ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: state.author!.lineas!.length,
                      itemBuilder: (context, index) {
                        return Center(
                            child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30.0),
                          child: Text(
                            '" ${state.author!.lineas![index]} "',
                            style: const TextStyle(
                              fontSize: 20,
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
  Author? value;
  _Titulo(this.value);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              // BlocProvider.of<AuthorTitleBloc>(context, listen: false)
              //     .add(const DeleteStatePoemByAuthor([]));
              Navigator.of(context).pop();
            }),
        Flexible(
          child: Padding(
            padding: const EdgeInsets.only(left: 50, right: 5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  value!.title.toString(),
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                const SizedBox(
                  height: 5,
                ),
              ],
            ),
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: Text(
                textAlign: TextAlign.left,
                'author: ${value!.author}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
