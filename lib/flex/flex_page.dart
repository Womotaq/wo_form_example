import 'package:flutter/material.dart';
import 'package:wo_form/wo_form.dart';
import 'package:wo_form_example/utils/extensions.dart';

class FlexPage extends StatelessWidget {
  const FlexPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        children: [
          ListTile(
            onTap: () => context.pushPage(
              WoForm(
                uiSettings: const WoFormUiSettings(
                  scrollable: false,
                ),
                children: [
                  WidgetNode(
                    builder: (context) => const ColoredBox(
                      color: Colors.redAccent,
                      child: Center(
                        child: Text('flex : unset'),
                      ),
                    ),
                  )
                ],
              ),
            ),
            leading: const Icon(Icons.menu),
            title: const Text('No expansion'),
            trailing: const Icon(Icons.chevron_right),
          ),
          const FormHeader(WoFormHeaderData(labelText: 'Vertical')),
          ListTile(
            onTap: () => context.pushPage(const FlexStandardVerticalPage()),
            leading: const Icon(Icons.expand),
            title: const Text('Standard'),
            trailing: const Icon(Icons.chevron_right),
          ),
          ListTile(
            onTap: () => context.pushPage(const FlexMultistepVerticalPage()),
            leading: const Icon(Icons.expand),
            title: const Text('Multistep'),
            trailing: const Icon(Icons.chevron_right),
          ),
          const FormHeader(WoFormHeaderData(labelText: 'Horizontal')),
          ListTile(
            onTap: () => context.pushPage(const FlexStandardHorizontalPage()),
            leading: const Icon(Icons.expand),
            title: const Text('Standard'),
            trailing: const Icon(Icons.chevron_right),
          ),
          ListTile(
            onTap: () => context.pushPage(const FlexMultistepHorizontalPage()),
            leading: const Icon(Icons.expand),
            title: const Text('Multistep'),
            trailing: const Icon(Icons.chevron_right),
          ),
        ],
      ),
    );
  }
}

class FlexStandardVerticalPage extends StatelessWidget {
  const FlexStandardVerticalPage({super.key});

  @override
  Widget build(BuildContext context) {
    return WoForm(
      uiSettings: const WoFormUiSettings(
        scrollable: false,
        submitMode: WoFormSubmitMode.standard(
          buttonPosition: SubmitButtonPosition.appBar,
        ),
      ),
      children: [
        WidgetNode(
          builder: (context) => const ColoredBox(
            color: Colors.redAccent,
            child: Center(
              child: Text('flex : unset'),
            ),
          ),
        ),
        WidgetNode(
          uiSettings: const InputUiSettings(flex: 1),
          builder: (context) => const ColoredBox(
            color: Colors.orangeAccent,
            child: Center(
              child: Text('flex : 1'),
            ),
          ),
        ),
        WidgetNode(
          uiSettings: const InputUiSettings(flex: 2),
          builder: (context) => const ColoredBox(
            color: Colors.green,
            child: Center(child: Text('flex : 2')),
          ),
        ),
      ],
    );
  }
}

class FlexMultistepVerticalPage extends StatelessWidget {
  const FlexMultistepVerticalPage({super.key});

  @override
  Widget build(BuildContext context) {
    return WoForm(
      uiSettings: const WoFormUiSettings(
        scrollable: false,
        submitMode: WoFormSubmitMode.multiStep(
            // buttonPosition: SubmitButtonPosition.appBar,
            ),
      ),
      children: [
        InputsNode(
          id: 'list',
          children: [
            WidgetNode(
              builder: (context) => const ColoredBox(
                color: Colors.redAccent,
                child: Center(
                  child: Text('flex : unset'),
                ),
              ),
            ),
            WidgetNode(
              uiSettings: const InputUiSettings(flex: 1),
              builder: (context) => const ColoredBox(
                color: Colors.orangeAccent,
                child: Center(
                  child: Text('flex : 1'),
                ),
              ),
            ),
            WidgetNode(
              uiSettings: const InputUiSettings(flex: 2),
              builder: (context) => const ColoredBox(
                color: Colors.green,
                child: Center(child: Text('flex : 2')),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class FlexStandardHorizontalPage extends StatelessWidget {
  const FlexStandardHorizontalPage({super.key});

  @override
  Widget build(BuildContext context) {
    return WoForm(
      uiSettings: const WoFormUiSettings(
        scrollable: false,
        submitMode: WoFormSubmitMode.standard(
          buttonPosition: SubmitButtonPosition.appBar,
        ),
      ),
      children: [
        InputsNode(
          id: 'list1',
          uiSettings: const InputsNodeUiSettings(
            direction: Axis.horizontal,
            flex: 1,
          ),
          children: [
            WidgetNode(
              builder: (context) => const ColoredBox(
                color: Colors.redAccent,
                child: Center(
                  child: Text('flex : unset'),
                ),
              ),
            ),
            WidgetNode(
              uiSettings: const InputUiSettings(flex: 2),
              builder: (context) => const ColoredBox(
                color: Colors.green,
                child: Center(child: Text('flex : 2')),
              ),
            ),
          ],
        ),
        WidgetNode(builder: (context) => const SizedBox.square(dimension: 16)),
        InputsNode(
          id: 'list2',
          uiSettings: const InputsNodeUiSettings(
            direction: Axis.horizontal,
            flex: 2,
          ),
          children: [
            WidgetNode(
              builder: (context) => const ColoredBox(
                color: Colors.redAccent,
                child: Center(
                  child: Text('flex : unset'),
                ),
              ),
            ),
            WidgetNode(
              uiSettings: const InputUiSettings(flex: 1),
              builder: (context) => const ColoredBox(
                color: Colors.orangeAccent,
                child: Center(
                  child: Text('flex : 1'),
                ),
              ),
            ),
            WidgetNode(
              uiSettings: const InputUiSettings(flex: 2),
              builder: (context) => const ColoredBox(
                color: Colors.green,
                child: Center(child: Text('flex : 2')),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class FlexMultistepHorizontalPage extends StatelessWidget {
  const FlexMultistepHorizontalPage({super.key});

  @override
  Widget build(BuildContext context) {
    return WoForm(
      uiSettings: const WoFormUiSettings(
        scrollable: false,
        submitMode: WoFormSubmitMode.multiStep(
            // buttonPosition: SubmitButtonPosition.appBar,
            ),
      ),
      children: [
        InputsNode(
          id: 'list',
          children: [
            InputsNode(
              id: 'list1',
              uiSettings: const InputsNodeUiSettings(
                direction: Axis.horizontal,
                flex: 1,
              ),
              children: [
                WidgetNode(
                  builder: (context) => const ColoredBox(
                    color: Colors.redAccent,
                    child: Center(
                      child: Text('flex : unset'),
                    ),
                  ),
                ),
                WidgetNode(
                  uiSettings: const InputUiSettings(flex: 2),
                  builder: (context) => const ColoredBox(
                    color: Colors.green,
                    child: Center(child: Text('flex : 2')),
                  ),
                ),
              ],
            ),
            WidgetNode(
                builder: (context) => const SizedBox.square(dimension: 16)),
            InputsNode(
              id: 'list2',
              uiSettings: const InputsNodeUiSettings(
                direction: Axis.horizontal,
                flex: 2,
              ),
              children: [
                WidgetNode(
                  builder: (context) => const ColoredBox(
                    color: Colors.redAccent,
                    child: Center(
                      child: Text('flex : unset'),
                    ),
                  ),
                ),
                WidgetNode(
                  uiSettings: const InputUiSettings(flex: 1),
                  builder: (context) => const ColoredBox(
                    color: Colors.orangeAccent,
                    child: Center(
                      child: Text('flex : 1'),
                    ),
                  ),
                ),
                WidgetNode(
                  uiSettings: const InputUiSettings(flex: 2),
                  builder: (context) => const ColoredBox(
                    color: Colors.green,
                    child: Center(child: Text('flex : 2')),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
