import 'package:flutter/material.dart';
import 'package:mpg_mobile/constants/dimensions.dart';
import 'package:mpg_mobile/ui/widgets/form_button.dart';
import 'package:mpg_mobile/ui/widgets/subtitle.dart';

class DescriptionBanner extends StatelessWidget {
  const DescriptionBanner(
      {required this.title,
      required this.preview,
      required this.fullDescription,
      Key? key})
      : super(key: key);
  final String title;
  final String preview;
  final List<DescriptionText> fullDescription;

  openFullDescription(context) {
    showDialog(
      context: context,
      builder: (context) => Material(
        child: ToolDescriptionDialog(
          title: title,
          fullDescription: fullDescription,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(30),
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadiusDirectional.circular(20),
        color: Colors.blue[200]?.withAlpha(50),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Subtitle(title: title),
          const SizedBox(
            height: 20,
          ),
          Container(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Text(preview),
          ),
          const SizedBox(
            height: 20,
          ),
          TextButton(
              child: const Text('Learn More'),
              onPressed: () => openFullDescription(context))
        ],
      ),
    );
  }
}

class ToolDescriptionDialog extends StatelessWidget {
  const ToolDescriptionDialog(
      {required this.title, required this.fullDescription, Key? key})
      : super(key: key);
  final String title;
  final List<DescriptionText> fullDescription;
  @override
  Widget build(BuildContext context) {
    bool isMobile = MediaQuery.of(context).size.width < Dimensions.m;

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(title),
      ),
      body: Container(
        margin: isMobile ? const EdgeInsets.all(15) : const EdgeInsets.all(50),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Description',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
              ),
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ...fullDescription.map((e) => Column(
                          children: [
                            if (e.type == ContentType.text)
                              Text(
                                e.text,
                                style: e.isTitle
                                    ? const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 20)
                                    : null,
                              ),
                            if (e.type == ContentType.image)
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    e.text,
                                    height: isMobile ? 230 : 400,
                                    filterQuality: FilterQuality.none,
                                  ),
                                ],
                              ),
                            const SizedBox(
                              height: 30,
                            ),
                          ],
                        ))
                  ],
                ),
              ),
              AppFormButton(
                  child: const Text('Close'),
                  onPressed: () => Navigator.of(context).pop())
            ],
          ),
        ),
      ),
    );
  }
}

class DescriptionText {
  String text;
  bool isTitle;
  ContentType type;

  DescriptionText(
      {required this.text,
      required this.isTitle,
      this.type = ContentType.text});
}

enum ContentType {
  text,
  image,
}
