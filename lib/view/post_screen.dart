import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mood_tracker/constant/icon.dart';
import 'package:mood_tracker/constant/gap.dart';
import 'package:mood_tracker/constant/size.dart';
import 'package:mood_tracker/view_model/post_view_model.dart';
import 'package:mood_tracker/widget/form_button.dart';

class PostScreen extends ConsumerStatefulWidget {
  const PostScreen({super.key});

  @override
  ConsumerState<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends ConsumerState<PostScreen> {
  late ScrollController scrollcontroller;
  late final TextEditingController _textEditingController =
      TextEditingController();
  late List<bool> isSelected = <bool>[
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false
  ];

  String _context = "";
  int _mood = -1;

  @override
  void dispose() {
    scrollcontroller.dispose();
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    scrollcontroller = ScrollController();
    _textEditingController.addListener(() {
      _context = _textEditingController.text;
    });
    super.initState();
  }

  void moodToggle(int index) {
    for (int i = 0; i < isSelected.length; i++) {
      if (i == index) {
        isSelected[i] = true;
        _mood = icons[i].runes.first;
      } else {
        isSelected[i] = false;
      }
    }
    setState(() {});
  }

  void _uploadPost() {
    if (_mood <= 0) return;
    ref.read(postForm.notifier).state = {
      "content": _context,
      "mood": _mood,
    };

    ref.read(postProvider.notifier).uploadPost(context);

    if (context.mounted) {
      setState(() {
        _textEditingController.text = "";
        _context = "";
        _mood = -1;
        isSelected = <bool>[
          false,
          false,
          false,
          false,
          false,
          false,
          false,
          false
        ];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'POST',
          style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.w600),
        ),
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Gaps.v32,
                  Text(
                    "Your think",
                    style: TextStyle(
                      fontSize: Sizes.size20,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  Gaps.v20,
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      children: [
                        TextFormField(
                          maxLength: 300,
                          controller: _textEditingController,
                          maxLines: null,
                          autocorrect: false,
                          decoration: InputDecoration(
                              filled: true,
                              fillColor: Theme.of(context)
                                  .primaryColor
                                  .withOpacity(0.2),
                              suffix: const SizedBox(
                                height: 120,
                                child: Text(''),
                              ),
                              border: InputBorder.none,
                              hintText: "Write it.",
                              hintStyle: const TextStyle(
                                  overflow: TextOverflow.ellipsis)),
                        ),
                      ],
                    ),
                  ),
                  Gaps.v10,
                  Text(
                    "Your mood",
                    style: TextStyle(
                      fontSize: Sizes.size20,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  Gaps.v10,
                  ToggleButtons(
                    color: Theme.of(context).primaryColor,
                    borderColor: Colors.transparent,
                    selectedBorderColor: Colors.transparent,
                    isSelected: isSelected,
                    onPressed: (index) => moodToggle(index),
                    constraints: const BoxConstraints(
                        maxWidth: 43.5,
                        minWidth: 43.5,
                        maxHeight: 43.5,
                        minHeight: 43.5),
                    children: [
                      for (var icon in icons)
                        Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: Sizes.size1),
                          alignment: Alignment.center,
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey), // 테두리 색상
                            borderRadius: BorderRadius.circular(5), // 모서리 둥글기
                            // color: Colors.white,  // 배경색상 (선택적)
                          ),
                          child: Text(
                            icon,
                            style: const TextStyle(fontSize: 25), // 텍스트 스타일
                          ),
                        ),
                    ],
                  ),
                  Gaps.v52,
                  GestureDetector(
                    onTap: _uploadPost,
                    child: FormButton(
                      disabled: _mood <= 0,
                      text: "Post",
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
