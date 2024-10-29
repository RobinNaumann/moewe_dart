import 'package:elbe/elbe.dart';
import 'package:moewe/moewe.dart';

void main() async {
  await Moewe(
      host: "open.moewe.app",
      project: "112dfa10cc07b914",
      app: "eddfa4d773c53ed5",
      debugConfigOverrides: {"fav_food": "pizza"}).init();

  moewe.setAppVersion("1.0.0", 0);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ElbeApp(
      debugShowCheckedModeBanner: false,
      router: GoRouter(
          routes: [GoRoute(path: "/", builder: (_, __) => const HomePage())]),
      theme: ThemeData.preset(color: Colors.blue),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _counter = 0;
  @override
  Widget build(BuildContext context) {
    return moeweUpdateWrapper(
      url: "https://moewe.app",
      child: Scaffold(
          title: "mœwe example",
          actions: [
            IconButton.integrated(
              icon: Icons.plus,
              onTap: () {
                setState(() {
                  _counter++;
                });
              },
            )
          ],
          child: Padded.all(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            '"plus" events logged:',
                            textAlign: TextAlign.center,
                          ),
                          Text.bodyL("$_counter", variant: TypeVariants.bold)
                        ]),
                    const Spaced.vertical(1),
                    Button(
                      style: ColorStyles.minorAlertError,
                      label: "cause a crash",
                      icon: Icons.flame,
                      onTap: () {
                        context.showToast("crash is logged");
                        throw "crash test";
                      },
                    ),
                    Button.minor(
                      label: "give feedback",
                      icon: Icons.messageSquare,
                      onTap: () {
                        MoeweFeedbackPage.show(context);
                      },
                    ),
                    const Spaced.vertical(1),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text('feature flag "fav_food":',
                            textAlign: TextAlign.center),
                        Text(moewe.config.flagString("fav_food") ?? "-",
                            variant: TypeVariants.bold,
                            textAlign: TextAlign.center),
                      ],
                    )
                  ].spaced()))),
    );
  }
}
