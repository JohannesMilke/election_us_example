import 'package:election_us_example/images.dart';
import 'package:election_us_example/model/app_state.dart';
import 'package:election_us_example/utils.dart';
import 'package:election_us_example/widget/speech_bubble_widget.dart';
import 'package:election_us_example/widget/vote_button_widget.dart';
import 'package:election_us_example/widget/wall_row_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  for (final urlImage in Images.all) {
    await Utils.loadAssetIntoCache(urlImage);
  }

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(MyApp());
}

enum Mood { great, good, bad }

class MyApp extends StatelessWidget {
  static final String title = 'Trump VS Biden';
  final appState = AppState();

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
        create: (_) => appState,
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: title,
          theme: ThemeData(primaryColor: Colors.white),
          home: MainPage(title: title),
        ),
      );
}

class MainPage extends StatefulWidget {
  final String title;

  const MainPage({
    @required this.title,
  });

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  Mood mood = Mood.great;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(Images.usaFlag, width: 64),
              const SizedBox(width: 12),
              Text(widget.title),
            ],
          ),
        ),
        body: Column(
          children: [
            Expanded(flex: 6, child: buildElection()),
            Expanded(flex: 4, child: buildButtons()),
          ],
        ),
      );

  Widget buildElection() {
    final text = buildAnimatedSwitcher(child: _getSpeechText(mood));

    return Container(
      color: Colors.green,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            Images.background,
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.fitHeight,
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8),
            alignment: Alignment.bottomCenter,
            child: buildAnimatedSwitcher(
              child: buildTrump(mood),
              duration: Duration(milliseconds: 100),
            ),
          ),
          SpeechBubbleWidget(child: text),
          Column(
            verticalDirection: VerticalDirection.up,
            children: List.generate(
              AppState.rows,
              (index) => Container(
                height: Provider.of<AppState>(context).stoneHeight,
                child: WallRowWidget(index: index),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _getSpeechText(Mood mood) {
    switch (mood) {
      case Mood.great:
        return Text(
          'I will win for sure!',
          key: ValueKey(1),
          style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
        );
      case Mood.good:
        return Text(
          'I will win. These 🧱 won\'t stop me from tweeting!',
          key: ValueKey(2),
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        );
      case Mood.bad:
        return Text(
          'Nooo please stop - seriously I will give up 😠',
          key: ValueKey(3),
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        );
      default:
        return Text('');
    }
  }

  Widget buildWall() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final stoneHeight = 65.0;
        final items = (constraints.maxHeight / stoneHeight).round();
        final lastStoneHeight = constraints.maxHeight % stoneHeight;

        return Column(
          children: List.generate(
            items,
            (index) {
              final isLastItem = items - 1 == index;

              return Container(
                height: isLastItem ? lastStoneHeight : stoneHeight,
                child: WallRowWidget(countStones: 4),
              );
            },
          ),
        );
      },
    );
  }

  Widget buildTrump(Mood mood) {
    switch (mood) {
      case Mood.great:
        return Image.asset(
          Images.moodGreat,
          key: ValueKey(1),
        );
      case Mood.good:
        return Image.asset(
          Images.moodGood,
          key: ValueKey(2),
        );
      case Mood.bad:
        return Image.asset(
          Images.moodBad,
          key: ValueKey(3),
        );
      default:
        return Container();
    }
  }

  Widget buildButtons() => Container(
        color: Colors.white,
        width: double.infinity,
        child: Stack(
          fit: StackFit.expand,
          children: [
            buildWall(),
            Column(
              children: [
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      VoteButtonWidget(
                        text: 'TRUMP Wins!',
                        color: Colors.green,
                        onClicked: voteForTrump,
                      ),
                      VoteButtonWidget(
                        text: 'BIDEN Wins!',
                        color: Colors.red,
                        onClicked: voteForBiden,
                      ),
                    ],
                  ),
                ),
                buildMadeWithFlutter(),
              ],
            ),
          ],
        ),
      );

  Widget buildMadeWithFlutter() => Container(
        margin: EdgeInsets.only(bottom: 24),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.white,
          ),
          child: Text(
            'Made With Flutter ♥️',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );

  Widget buildAnimatedSwitcher({@required Widget child, Duration duration}) =>
      AnimatedSwitcher(
        duration: duration ?? Duration(milliseconds: 300),
        switchInCurve: Curves.easeInQuad,
        switchOutCurve: Curves.easeOutQuad,
        child: child,
      );

  Future voteForBiden() async {
    final newMoodIndex = mood.index + 1;
    if (newMoodIndex >= Mood.values.length) return;

    final state = Provider.of<AppState>(context, listen: false);
    void changeMood() => setState(() {
          this.mood = Mood.values[newMoodIndex];
        });

    switch (mood) {
      case Mood.great:
        await state.insertBrickStones(2, duration: Duration(seconds: 1));
        changeMood();
        break;
      case Mood.good:
        await state.insertBrickStones(
          2,
          duration: Duration(milliseconds: 300),
        );
        await state.insertBrickStones(
          2,
          duration: Duration(seconds: 2),
        );
        changeMood();
        await Future.delayed(Duration(seconds: 3));
        await state.insertBrickStones(
          12,
          duration: Duration(milliseconds: 100),
        );
        break;
      case Mood.bad:
        break;
    }
  }

  Future voteForTrump() async {
    final newMoodIndex = mood.index - 1;
    if (newMoodIndex < 0) return;

    final state = Provider.of<AppState>(context, listen: false);
    void changeMood() => setState(() {
          this.mood = Mood.values[newMoodIndex];
        });

    switch (mood) {
      case Mood.great:
        break;
      case Mood.good:
        await state.deleteBrickStones(1);
        changeMood();
        await state.deleteBrickStones(1);
        break;
      case Mood.bad:
        await state.deleteBrickStones(
          16,
          duration: Duration(milliseconds: 100),
        );
        changeMood();
        break;
    }
  }
}
