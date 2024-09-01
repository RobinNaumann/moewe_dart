import 'package:flutter/material.dart';
import 'package:moewe/moewe.dart';
import 'package:moewe/src/ui/m_ui.dart';

class FeedbackType {
  final String key;
  final String label;

  const FeedbackType(this.key, this.label);
}

class FeedbackLabels {
  final String header;
  final String description;
  final String titleHint;
  final String messageHint;
  final String? contactDescription;
  final String? contactHint;
  final String submitLabel;
  final String toastNotValid;
  final String toastSuccess;
  final String toastError;

  final List<FeedbackType> types;

  const FeedbackLabels(
      {this.header = "feedback",
      this.description = "Thank you for helping us improve our app",
      this.titleHint = "title",
      this.messageHint = "message",
      this.contactDescription =
          "if you want us to contact you, please provide your email address or social media handle",
      this.contactHint = "contact info",
      this.submitLabel = "submit",
      this.toastNotValid = "Please fill out title and message",
      this.toastSuccess = "Thank you for your feedback",
      this.toastError = "could not send feedback",
      this.types = const [
        FeedbackType("issue", "Issue"),
        FeedbackType("feature", "Feature Request"),
        FeedbackType("question", "Question"),
      ]});
}

class MoeweFeedbackPage extends StatefulWidget {
  final MoeweTheme theme;
  final FeedbackLabels labels;

  const MoeweFeedbackPage({
    super.key,
    this.theme = const MoeweTheme(),
    this.labels = const FeedbackLabels(),
  });

  @override
  createState() => _State();
}

class _State extends State<MoeweFeedbackPage> {
  late final t = widget.theme;
  late final l = widget.labels;

  final TextEditingController titleController = TextEditingController();
  final TextEditingController messageController = TextEditingController();
  final TextEditingController contactController = TextEditingController();
  late String type = l.types.firstOrNull?.key ?? "";
  bool? sent;

  rem([double n = 1]) => n * t.remSize;
  late final backColor = t.darkTheme ? Colors.black : Colors.white;
  late final frontColor = t.darkTheme ? Colors.white : Colors.black;

  late final Color borderColor =
      (t.darkTheme ? Colors.white : Colors.black).withOpacity(.2);

  late final borderStyle = OutlineInputBorder(
    borderSide: BorderSide(color: borderColor, width: t.borderWidth),
    borderRadius: BorderRadius.circular(t.borderRadius),
  );

  _showToast(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  _submit() async {
    final title = titleController.text;
    final message = messageController.text;
    final contact = contactController.text;

    if (title.isEmpty || message.isEmpty) {
      _showToast(context, l.toastNotValid);
      return;
    }

    setState(() => sent = false);
    try {
      await moewe.feedback(title, message, type, contact);
      setState(() => sent = true);
    } catch (e) {
      _showToast(context, l.toastError);
      setState(() => sent = null);
    }
  }

  _submitButton() {
    return GestureDetector(
        onTap: () => _submit(),
        child: Container(
          decoration: BoxDecoration(
            color: t.colorAccent,
            borderRadius: BorderRadius.circular(t.borderRadius),
          ),
          height: t.remSize * 3,
          child: Center(
            child: Text(l.submitLabel,
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: t.colorOnAccent)),
          ),
        ));
  }

  _dropdownButton() {
    return DecoratedBox(
        decoration: BoxDecoration(
          border: Border.all(color: borderColor, width: t.borderWidth),
          borderRadius: BorderRadius.circular(t.borderRadius),
        ),
        child: DropdownButton(
            value: type,
            padding: EdgeInsets.symmetric(horizontal: t.remSize),
            isExpanded: true,
            underline: Container(),
            borderRadius: BorderRadius.circular(t.borderRadius),
            items: l.types
                .map((type) => DropdownMenuItem(
                      value: type.key,
                      child: Text(type.label),
                    ))
                .toList(),
            onChanged: (v) => setState(() => type = v ?? "")));
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: (t.darkTheme ? ThemeData.dark() : ThemeData.light()).copyWith(
        canvasColor: backColor,
        scaffoldBackgroundColor: backColor,
        snackBarTheme: SnackBarThemeData(
          backgroundColor: frontColor,
          contentTextStyle: TextStyle(color: backColor),
        ),
        appBarTheme: AppBarTheme(
          color: Colors.transparent,
          titleTextStyle: TextStyle(color: frontColor),
          iconTheme: IconThemeData(color: frontColor),
          elevation: 0,
        ),
        primaryColor: widget.theme.colorAccent,
        inputDecorationTheme: InputDecorationTheme(
            hintStyle: TextStyle(
                //color: Colors.black.withOpacity(.5),
                fontWeight: FontWeight.normal),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: widget.theme.colorAccent, width: t.borderWidth * 2),
              borderRadius: BorderRadius.circular(8),
            ),
            enabledBorder: borderStyle,
            border: borderStyle),
      ),
      child: Scaffold(
          appBar: AppBar(
              leading: Navigator.canPop(context)
                  ? IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    )
                  : null,
              title: Text(
                l.header,
                style: TextStyle(fontWeight: FontWeight.bold),
              )),
          body: Padding(
            padding: EdgeInsets.fromLTRB(rem(), 0, rem(), rem()),
            child: sent != null
                ? Center(
                    child: sent == true
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.check_circle,
                                  color: t.colorAccent, size: rem(4)),
                              SizedBox(height: rem(1)),
                              Text(
                                l.toastSuccess,
                                style: TextStyle(color: t.colorAccent),
                              ),
                            ],
                          )
                        : CircularProgressIndicator())
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: ListView(
                          children: [
                            SizedBox(height: rem(1)),
                            Text(l.description),
                            SizedBox(height: rem(1)),
                            TextField(
                              controller: titleController,
                              maxLines: 1,
                              decoration: InputDecoration(
                                hintText: l.titleHint,
                              ),
                            ),
                            SizedBox(height: rem(1)),
                            if (l.types.isNotEmpty) _dropdownButton(),
                            SizedBox(height: rem(1)),
                            TextField(
                              controller: messageController,
                              minLines: 4,
                              maxLines: 8,
                              decoration:
                                  InputDecoration(hintText: l.messageHint),
                            ),
                            SizedBox(height: rem(2)),
                            if (l.contactDescription != null)
                              Text(l.contactDescription ?? ""),
                            SizedBox(height: rem()),
                            if (l.contactHint != null)
                              TextField(
                                controller: contactController,
                                maxLines: 1,
                                decoration:
                                    InputDecoration(hintText: l.contactHint),
                              ),
                            SizedBox(height: rem()),
                          ],
                        ),
                      ),
                      SizedBox(height: 16),
                      _submitButton(),
                    ],
                  ),
          )),
    );
  }
}
