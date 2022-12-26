import 'package:bucket_list/models/Bucket.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}

/// 홈 페이지
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<BucKet> _bucketList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("버킷 리스트"),
      ),
      body: _bucketList.isEmpty
          ? const Center(
              child: Text(
                "버킷 리스트를 작성해 주세요.",
              ),
            )
          : ListView.builder(
              itemCount: _bucketList.length,
              itemBuilder: (context, index) {
                BucKet item = _bucketList[index];
                return ListTile(
                  title: Text(
                    item.title,
                    style: TextStyle(
                      fontSize: 24,
                      color: item.isDone ? Colors.grey : Colors.black,
                      decoration: item.isDone
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                    ),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      // 삭제를 위한 다이얼로그 노출
                      showDeleteDialog(context, index);
                    },
                  ),
                  onTap: () {
                    setState(() {
                      item.isDone = !item.isDone;
                    });
                  },
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          String? item = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => CreatePage()),
          );
          if (item != null) {
            setState(() {
              _bucketList.add(BucKet(item, false));
            });
          }
        },
      ),
    );
  }

  void showDeleteDialog(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('삭제하시겠습니까?'),
          actions: [
            TextButton(
              onPressed: (){
                Navigator.pop(context);
              },
              child: const Text('취소'),
            ),
            TextButton(
              onPressed: (){
                setState(() {
                  _bucketList.removeAt(index);
                });
                Navigator.pop(context);
              },
              child: const Text('삭제',style: TextStyle(
                color: Colors.pinkAccent
              ),),
            ),
          ],
        );
      },
    );
  }
}

/// 버킷 생성 페이지
class CreatePage extends StatefulWidget {
  const CreatePage({Key? key}) : super(key: key);

  @override
  State<CreatePage> createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
  TextEditingController _textController = TextEditingController();
  String? errorMSg;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("버킷리스트 작성"),
        // 뒤로가기 버튼
        leading: IconButton(
          icon: Icon(CupertinoIcons.chevron_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // 텍스트 입력창
            TextField(
              autofocus: true,
              decoration: InputDecoration(
                  hintText: "하고 싶은 일을 입력하세요", errorText: errorMSg),
              controller: _textController,
            ),
            SizedBox(height: 32),
            // 추가하기 버튼
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                child: Text(
                  "추가하기",
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                onPressed: () {
                  // 추가하기 버튼 클릭시
                  String item = _textController.text;
                  if (item.isEmpty) {
                    setState(() {
                      errorMSg = '내용을 입력해주세요';
                    });
                  } else {
                    setState(() {
                      errorMSg = null;
                      Navigator.pop(context, item);
                    });
                  }
                  print(item);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
