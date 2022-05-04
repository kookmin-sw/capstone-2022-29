// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:frontend/components/app_bar.dart';
import 'package:frontend/components/list_color.dart';
import 'package:frontend/pages/navigator.dart';

class NoticePage extends StatefulWidget {
  NoticePage({Key? key, this.user_id}) : super(key: key);
  String? user_id;

  @override
  State<NoticePage> createState() => _NoticePageState();
}

class _NoticePageState extends State<NoticePage> {
  List<Map> notice = [
    {
      'title': '뉴익이란?',
      'content': '''
  ‘뉴익’은 ‘뉴스를 익히다'라는 의미입니다.

  본 ‘뉴익’은 뉴스 기사 빅 데이터를 토대로 토픽 모델링을 진행하여, 시기 별 주요 사건의 흐름을 한눈에 파악할 수 있게 합니다.
  본 ‘뉴익’은 기사 본문을 요약하고, 유사한 뉴스들을 묶어서 보여주기 때문에 사용자가 더욱 빠르고 편리하게 원하는 내용을 찾을 수 있습니다.


  The app conducts topic modeling algorithm with big data of news article so that you can grasp the flow of major events by period at a glance. 
  Also, it summarizes the text of the article and shows similar news in a bundle.
  ''',
    },
    {
      'title': '이용약관 안내',
      'content': '''
  '뉴익'에서 적용되는 약관 및 정책입니다.

  제 1조 (목적 및 정의)

  '뉴익'을 이용해 주셔서 감사합니다. 본 약관은 여러분이 '뉴익'을 이용하는데 필요한 권리, 의무 및 책임사항, 이용조건 및 절차 등 기본적인 사항을 규정하고 있으므로 조금만 시간을 내서 주의 깊게 읽어주시기 바랍니다.

  제 2조 (약관의 효력 및 변경)

  ① 본 약관의 내용은 '뉴익' 또는 개별 서비스의 화면에 게시하거나 기타의 방법으로 공지하고, 본 약관에 동의한 여러분 모두에게 그 효력이 발생합니다.

  ② '뉴익'은 필요한 경우 관련법령을 위배하지 않는 범위 내에서 본 약관을 변경할 수 있습니다. 본 약관이 변경되는 경우 '뉴익'은 변경사항을 시행일자 15일 전부터 여러분에게 서비스 공지사항에서 공지 또는 통지하는 것을 원칙으로 하며, 피치 못하게 여러분에게 불리한 내용으로 변경할 경우에는 그 시행일자 30일 전부터 '뉴익'에 등록된 카카오 이메일 주소로 이메일 발송 등으로 개별적으로 알려 드리겠습니다.

  ③ '뉴익'이 전항에 따라 공지 또는 통지를 하면서 공지 또는 통지일로부터 개정약관 시행일 7일 후까지 거부의사를 표시하지 아니하면 승인한 것으로 본다는 뜻을 명확하게 고지하였음에도 여러분의 의사표시가 없는 경우에는 변경된 약관을 승인한 것으로 봅니다. 여러분이 개정약관에 동의하지 않을 경우 여러분은 이용계약을 해지할 수 있습니다.

  제 3조 (약관 외 준칙)

  본 약관에 규정되지 않은 사항에 대해서는 관련법령 또는 '뉴익'이 정한 개별 서비스의 이용약관, 운영정책 및 규칙 등(이하 ‘세부지침’)의 규정에 따릅니다.
  ''',
    },
    {
      'title': '개인정보 처리방침 안내',
      'content': '''
  '뉴익'의 개인정보 처리방침입니다.

  1. 개인정보 처리방침이란?

  '뉴익'은 이용자의 '동의를 기반으로 개인정보를 수집·이용 및 제공’하고 있으며, ‘이용자의 권리 (개인정보 자기결정권)를 적극적으로 보장’합니다. 회사는 정보통신서비스제공자가 준수하여야 하는 대한민국의 관계 법령 및 개인정보보호 규정, 가이드라인을 준수하고 있습니다. “개인정보처리방침”이란 이용자의 소중한 개인정보를 보호함으로써 이용자가 안심하고 서비스를 이용할 수 있도록 회사가 준수해야 할 지침을 의미합니다.

  본 개인정보처리방침은 '뉴익'이 제공하는 서비스에 적용됩니다.

  2. 개인정보 수집

  서비스 제공을 위한 필요 최소한의 개인정보를 수집하고 있습니다.

  로그인 시 또는 서비스 이용 과정에서 홈페이지  또는 개별 어플리케이션이나 프로그램 등을 통해 아래와 같은 서비스 제공을 위해 필요한 최소한의 개인정보를 수집하고 있습니다.

  [로그인 시]
    필수
  닉네임, 프로필 사진
    선택
  카카오계정(이메일)

  본 서비스에서는 특화된 여러 기능들을 제공하기 위해 '카카오계정'에서 공통으로 수집하는 정보 이욍 이용자에게 동의를 받고 추가적인 개인정보를 수집할 수 있습니다.
  - 필수정보란? : 해당 서비스의 본질적 기능을 수행하기 위한 정보
  - 선택정보란? : 보다 특화된 서비스를 제공하기 위해 추가 수집하는 정보 (선택 정보를 입력하지 않은 경우에도 서비스 이용 제한은 없습니다.)
  ''',
    },
    {
      'title': '청소년보호정책',
      'content': '''
  '뉴익'의 청소년 보호정책입니다.

  '뉴익'은 모든 연령대가 자유롭게 이용할 수 있는 공간으로써 유해 정보로부터 청소년을 보호하고 청소년의 안전한 인터넷 사용을 돕기 위해 아래와 같이 정보통신망 이용촉진 및 정보보호 등에 관한 법률에서 정한 청소년 보호정책을 시행하고 있습니다.

  앞으로도 '뉴익'은 깨끗하고 건전한 인터넷 문화를 조성하고 청소년이 올바른 정보공유 활동을 통하여 건강한 인격체로 성장할 수 있도록 더욱 노력하겠습니다.
  ''',
    },
    {
      'title': 'Contact us',
      'content': '''
  뉴익[뉴스를 익히다] 입니다!

  대학교: 국민대학교 소프트웨어융합대학
  학   과: 소프트웨어학부
  과목명: 다학제간캡스톤디자인I 

  프로젝트 29조
  
  20191604 백연선
  20191650 이한정
  20191670 조나영
  20191686 최혜원
  ''',
    },
  ];

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color.fromRGBO(247, 247, 247, 1),
      appBar: appBar(size, '공지사항', context, true, false),
      body: Container(
        margin: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
        ),
        child: ListView.builder(
          itemCount: notice.length,
          itemBuilder: (context, index) {
            return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return NavigatorPage(
                          index: 7,
                          title: notice[index]['title'],
                          content: notice[index]['content'],
                          user_id: widget.user_id,
                        );
                      },
                    ),
                  );
                },
                child: ColorList(
                  title: notice[index]['title'],
                  content: notice[index]['content'],
                ));
          },
        ),
      ),
    );
  }
}
