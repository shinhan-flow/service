import 'dart:developer';

import 'package:day_night_time_picker/lib/daynight_timepicker.dart';
import 'package:day_night_time_picker/lib/state/time.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:shinhan_flow/account/provider/account_provider.dart';
import 'package:shinhan_flow/account/view/account_transaction_history_screen.dart';
import 'package:shinhan_flow/auth/provider/auth_provider.dart';
import 'package:shinhan_flow/auth/view/login_screen.dart';
import 'package:shinhan_flow/common/component/default_appbar.dart';
import 'package:shinhan_flow/common/component/sliver_pagination_list_view.dart';
import 'package:shinhan_flow/flow/view/trigger_category_screen.dart';
import 'package:shinhan_flow/product/view/product_account_screen.dart';
import 'package:shinhan_flow/theme/text_theme.dart';
import 'package:shinhan_flow/util/util.dart';

import 'account/component/account_card.dart';
import 'account/model/account_model.dart';
import 'account/view/account_transfer_screen.dart';
import 'common/model/bank_model.dart';
import 'common/model/default_model.dart';
import 'flow/model/flow_model.dart';
import 'flow/provider/flow_provider.dart';

class HomeScreen extends StatefulWidget {
  static String get routeName => 'home';

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: ExpandableFab.location,
      // floatingActionButton: ExpandableFab(
      //   type: ExpandableFabType.fan,
      //   pos: ExpandableFabPos.center,
      //   overlayStyle: ExpandableFabOverlayStyle(
      //       color: Colors.black.withOpacity(0.5), blur: 2),
      //   fanAngle: 60,
      //   children: [
      //     FloatingActionButton.small(
      //       heroTag: null,
      //       child: const Icon(Icons.edit),
      //       onPressed: () {},
      //     ),
      //     FloatingActionButton.small(
      //       heroTag: null,
      //       child: const Icon(Icons.search),
      //       onPressed: () {},
      //     ),
      //   ],
      // ),
      bottomNavigationBar: Container(
        constraints: BoxConstraints.tight(Size(
          double.infinity,
          90.h,
        )),
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(color: Color(0xFFDFDFDF)),
          ),
        ),
        child: Align(
          child: Container(
            constraints: BoxConstraints.tight(Size(110.w, 60.h)),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30.r),
              gradient: const LinearGradient(
                  colors: [Color(0xFF0046FF), Color(0xFFAFB9D3)]),
            ),
            child:
                // ExpandableFab(
                //   // type: ExpandableFabType.fan,
                //   pos: ExpandableFabPos.center,
                //   fanAngle: 30,
                //   children: [
                //     FloatingActionButton.small(
                //       heroTag: null,
                //       child: const Icon(Icons.edit),
                //       onPressed: () {},
                //     ),
                //     FloatingActionButton.small(
                //       heroTag: null,
                //       child: const Icon(Icons.search),
                //       onPressed: () {},
                //     ),
                //   ],
                // )

                ElevatedButton(
                    onPressed: () {
                      context.pushNamed(TriggerCategoryScreen.routeName);
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent),
                    child: Text(
                      "NEW",
                      style: SHFlowTextStyle.button.copyWith(
                        color: Colors.white,
                      ),
                    )),
          ),
        ),
      ),
      body: NestedScrollView(
          controller: _scrollController,
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return [
              DefaultAppBar(
                isSliver: true,
                leading: Row(
                  children: [
                    SizedBox(width: 15.w),
                    Image.asset(
                      AssetUtil.getAssetPath(name: 'logo', extension: 'png'),
                      width: 28.r,
                      height: 28.r,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      "신한 Flow",
                      style: SHFlowTextStyle.appbar,
                    ),
                  ],
                ),
                actions: [
                  Row(
                    children: [
                      Image.asset(
                        AssetUtil.getAssetPath(
                          name: 'profile',
                          extension: 'png',
                        ),
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        "김정현님",
                        style: SHFlowTextStyle.subTitle,
                      ),
                      SizedBox(width: 15.w),
                    ],
                  ),
                ],
              )
            ];
          },
          body: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    _AccountCardComponent(),
                    _QuickComponent(),
                    _FlowComponent(),
                  ],
                ),
              ),
              SliverPadding(
                padding: EdgeInsets.only(
                  left: 28.w,
                  right: 28.w,
                  bottom: 12.h,
                ),
                sliver: DisposeSliverPaginationListView(
                  provider: flowProvider,
                  itemBuilder: (BuildContext _, int idx, Base pModel) {
                    final model = pModel as FlowModel;
                    return FlowCard.fromModel(
                      model: model,
                    );
                  },
                  skeleton: Container(),
                  controller: _scrollController,
                  emptyWidget: Container(),
                ),
              ),
              // SliverPadding(
              //   padding: EdgeInsets.only(
              //     left: 28.w,
              //     right: 28.w,
              //     bottom: 12.h,
              //   ),
              //   sliver: SliverList.separated(
              //     itemBuilder: (_, idx) => FlowCard(),
              //     separatorBuilder: (_, idx) => SizedBox(
              //       height: 12.h,
              //     ),
              //     itemCount: 10,
              //   ),
              // ),
            ],
          )),
    );
  }
}

class _AccountCardComponent extends ConsumerWidget {
  const _AccountCardComponent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 28.w, vertical: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextButton(
              onPressed: () {
                ref.read(authProvider.notifier).logout();
              },
              child: Text("임시 로그아웃")),
          TextButton(
              onPressed: () {
                context.pushNamed(ProductAccountScreen.routeName);
              },
              child: Text("수시 입출금 상품")),
          Text(
            '금융 정보를 알려드려요',
            style: SHFlowTextStyle.subTitle,
          ),
          SizedBox(height: 12.h),
          Consumer(
            builder: (BuildContext context, WidgetRef ref, Widget? child) {
              final result = ref.watch(accountListProvider);
              if (result is LoadingModel) {
                return CircularProgressIndicator();
              } else if (result is ErrorModel) {
                return Text("error");
              }
              final modelList = (result
                      as ResponseModel<BankListBaseModel<AccountDetailModel>>)
                  .data!
                  .rec;
              if (modelList.isEmpty) {
                return InkWell(
                  onTap: () {
                    context.pushNamed(ProductAccountScreen.routeName);
                  },
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 24.w, vertical: 30.h),
                    decoration: BoxDecoration(
                        color: Colors.blueGrey,
                        borderRadius: BorderRadius.circular(12.r)),
                    child: Text(
                      '입출금 계좌 만들러가기',
                      style: SHFlowTextStyle.subTitle
                          .copyWith(color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              }

              final model = modelList.first;
              return GestureDetector(
                onTap: () {
                  context.pushNamed(AccountTransactionHistoryScreen.routeName);
                },
                child: AccountCard.fromModel(
                  model: model,
                  onTap: () {
                    context.pushNamed(AccountTransferScreen.routeName,
                        extra: model);
                  },
                ),
              );
            },
          )
        ],
      ),
    );
  }
}

class _QuickComponent extends StatelessWidget {
  const _QuickComponent({super.key});

  @override
  Widget build(BuildContext context) {
    List<int> quicks = [1, 2, 3, 4, 5, 6, 7];
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 28.w),
            child: Text(
              "빠른 시작",
              style: SHFlowTextStyle.subTitle,
            ),
          ),
          SizedBox(height: 12.h),
          Container(
            constraints: BoxConstraints.loose(Size(double.infinity, 135.r)),
            child: ListView.separated(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: 28.w),
                itemBuilder: (_, idx) {
                  return QuickCard();
                },
                separatorBuilder: (_, idx) => SizedBox(
                      width: 30.w,
                    ),
                itemCount: quicks.length),
          )
        ],
      ),
    );
  }
}

class QuickCard extends StatelessWidget {
  const QuickCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: const Alignment(0, -1),
      child: Container(
        constraints: BoxConstraints.tight(Size(128.r, 128.r)),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.r),
            color: Colors.white,
            border: Border.all(color: const Color(0xFF0057FF), width: 2.r),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF000000).withOpacity(0.25),
                offset: Offset(0, 4.h),
                blurRadius: 4.r,
              ),
            ]),
      ),
    );
  }
}

class _FlowComponent extends ConsumerWidget {
  const _FlowComponent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 28.w, vertical: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            "내가 만든 Flow",
            style: SHFlowTextStyle.subTitle,
          ),
          // SizedBox(height: 12.h),
          // ListView.separated(
          //     itemBuilder: (_, idx) => FlowCard(),
          //     separatorBuilder: (_, idx) => SizedBox(height: 12.h,),
          //     itemCount: 10)
        ],
      ),
    );
  }
}

class FlowCard extends StatefulWidget {
  final int id;
  final int memberId;
  final String title;
  final String description;
  bool enable;

  FlowCard(
      {super.key,
      required this.memberId,
      required this.title,
      required this.description,
      required this.enable,
      required this.id});

  factory FlowCard.fromModel({required FlowModel model}) {
    return FlowCard(
      memberId: model.memberId,
      title: model.title,
      description: model.description,
      enable: model.enable,
      id: model.id,
    );
  }

  @override
  State<FlowCard> createState() => _FlowCardState();
}

class _FlowCardState extends State<FlowCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(18.r),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.r),
        color: const Color(0xFF3F73FF),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  widget.title,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: SHFlowTextStyle.subTitle.copyWith(
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 12.h),
                Text(
                  widget.description,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: SHFlowTextStyle.labelSmall.copyWith(
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 24.w),
          Consumer(
            builder: (BuildContext context, WidgetRef ref, Widget? child) {
              return Switch(
                value: widget.enable,
                onChanged: (v) async {
                  final result = await ref
                      .read(toggleFlowProvider(flowId: widget.id).future);
                  if (result is ErrorModel) {
                  } else {
                    widget.enable = (result as ResponseModel<bool>).data!;
                  }
                  setState(() {});
                },
                activeColor: Colors.white,
                activeTrackColor: const Color(0xFF0046FF),
                inactiveTrackColor: const Color(0xFFCBCFD7),
                inactiveThumbColor: Colors.white,
                trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
                thumbIcon: WidgetStateProperty.all(const Icon(null)),
              );
            },
          ),
        ],
      ),
    );
  }
}
