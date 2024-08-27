import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:shinhan_flow/action/param/action_balance_notification_param.dart';
import 'package:shinhan_flow/action/param/action_exchange_rate_notification_param.dart';
import 'package:shinhan_flow/action/param/action_text_notification_param.dart';
import 'package:shinhan_flow/common/component/default_appbar.dart';
import 'package:shinhan_flow/common/component/default_text_button.dart';
import 'package:shinhan_flow/flow/model/enum/action_category.dart';
import 'package:shinhan_flow/flow/model/enum/trigger_category.dart';
import 'package:shinhan_flow/flow/model/enum/widget/flow_property.dart';
import 'package:shinhan_flow/flow/param/enum/flow_type.dart';
import 'package:shinhan_flow/flow/param/trigger/account/trigger_balance_account_param.dart';
import 'package:shinhan_flow/flow/param/trigger/account/trigger_deposit_account_param.dart';
import 'package:shinhan_flow/flow/param/trigger/account/trigger_transfer_account_param.dart';
import 'package:shinhan_flow/flow/param/trigger/account/trigger_withdraw_account_param.dart';
import 'package:shinhan_flow/flow/param/trigger/trigger_product_param.dart';
import 'package:shinhan_flow/flow/provider/widget/time_form_provider.dart';
import 'package:shinhan_flow/flow/provider/widget/trigger_category_provider.dart';
import 'package:shinhan_flow/flow/provider/widget/flow_form_provider.dart';
import 'package:shinhan_flow/trigger/model/enum/product_property.dart';
import 'package:shinhan_flow/trigger/view/account_trigger_screen.dart';
import 'package:shinhan_flow/trigger/view/time_trigger_screen.dart';
import 'package:shinhan_flow/theme/text_theme.dart';

import '../../action/model/enum/action_type.dart';
import '../../action/view/action_notification_screen.dart';
import '../../common/component/bottom_nav_button.dart';
import '../../trigger/view/exchange_trigger_screen.dart';
import '../../trigger/view/product_trigger_screen.dart';
import '../param/trigger/trigger_date_time_param.dart';
import '../param/trigger/trigger_exchange_param.dart';
import '../param/trigger/trigger_param.dart';

class FlowInitScreen extends StatelessWidget {
  static String get routeName => 'flowInit';

  const FlowInitScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Consumer(
        builder: (BuildContext context, WidgetRef ref, Widget? child) {
          final valid = ref.watch(flowFormProvider).valid;
          return BottomNavButton(
              child: DefaultTextButton(
            onPressed: () {},
            text: '생성하기',
            able: valid,
          ));
        },
      ),
      body: NestedScrollView(
          headerSliverBuilder: (_, __) {
            return [
              const DefaultAppBar(
                isSliver: true,
                title: 'Flow 생성',
              )
            ];
          },
          body: CustomScrollView(
            slivers: [
              SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 28.h),
                sliver: SliverMainAxisGroup(slivers: [
                  SliverToBoxAdapter(
                    child: _TriggerComponent(
                      property: FlowProperty.trigger,
                    ),
                  ),
                  SliverToBoxAdapter(child: SizedBox(height: 40.h)),
                  SliverToBoxAdapter(
                    child: _TriggerComponent(
                      property: FlowProperty.action,
                    ),
                  ),
                ]),
              ),
            ],
          )),
    );
  }
}

class _ActionComponent extends StatelessWidget {
  const _ActionComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class _TriggerComponent extends ConsumerWidget {
  final FlowProperty property;

  const _TriggerComponent({
    super.key,
    required this.property,
  });

  Widget getTriggerAddBtn(
      BuildContext context, Set<TriggerCategoryType> triggers, WidgetRef ref) {
    return _AddButton(
      onTap: () {
        Set<TriggerCategoryType> tempSelected = {};
        showModalBottomSheet(
            showDragHandle: true,
            isScrollControlled: true,
            context: context,
            builder: (_) {
              final unSelectedTriggers = TriggerCategoryType.values.toList()
                ..removeWhere((t) => triggers.contains(t));
              final cards = unSelectedTriggers
                  .map((t) => _FlowInitCard(
                        triggerType: t,
                        onTap: () {
                          if (!tempSelected.add(t)) {
                            tempSelected.remove(t);
                          }
                        },
                      ))
                  .toList();

              return StatefulBuilder(
                  builder: (BuildContext context, StateSetter setState) {
                return Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        "추가로 선택하실 조건은 무엇인가요?",
                        style: SHFlowTextStyle.subTitle,
                      ),
                      SizedBox(height: 20.h),
                      ListView.separated(
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (_, idx) {
                            return _FlowInitCard(
                              triggerType: unSelectedTriggers[idx],
                              onTap: () {
                                setState(() {
                                  if (!tempSelected
                                      .add(unSelectedTriggers[idx])) {
                                    tempSelected
                                        .remove(unSelectedTriggers[idx]);
                                  }
                                });
                              },
                              isSelected: tempSelected
                                  .contains(unSelectedTriggers[idx]),
                            );
                          },
                          separatorBuilder: (_, idx) => SizedBox(height: 12.h),
                          itemCount: cards.length),
                      SizedBox(height: 20.h),
                      Align(
                        child: DefaultTextButton(
                          onPressed: tempSelected.isNotEmpty
                              ? () {
                                  triggers.addAll(tempSelected);
                                  final newTriggers = triggers.toSet();

                                  ref
                                      .read(triggerCategoryProvider.notifier)
                                      .update((t) => newTriggers);
                                  context.pop();
                                }
                              : null,
                          text: "선택 완료",
                          able: tempSelected.isNotEmpty,
                        ),
                      ),
                      SizedBox(height: 20.h),
                    ],
                  ),
                );
              });
            });
      },
    );
  }

  Widget getActionAddBtn(
      BuildContext context, Set<ActionCategoryType> triggers, WidgetRef ref) {
    return _AddButton(
      onTap: () {
        Set<ActionCategoryType> tempSelected = {};
        showModalBottomSheet(
            showDragHandle: true,
            isScrollControlled: true,
            context: context,
            builder: (_) {
              final unSelectedTriggers = ActionCategoryType.values.toList()
                ..removeWhere((t) => triggers.contains(t));
              final cards = unSelectedTriggers
                  .map((t) => _FlowInitCard(
                        actionType: t,
                        onTap: () {
                          if (!tempSelected.add(t)) {
                            tempSelected.remove(t);
                          }
                        },
                      ))
                  .toList();

              return StatefulBuilder(
                  builder: (BuildContext context, StateSetter setState) {
                return Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        "추가로 선택하실 조건은 무엇인가요?",
                        style: SHFlowTextStyle.subTitle,
                      ),
                      SizedBox(height: 20.h),
                      ListView.separated(
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (_, idx) {
                            return _FlowInitCard(
                              actionType: unSelectedTriggers[idx],
                              onTap: () {
                                setState(() {
                                  if (!tempSelected
                                      .add(unSelectedTriggers[idx])) {
                                    tempSelected
                                        .remove(unSelectedTriggers[idx]);
                                  }
                                });
                              },
                              isSelected: tempSelected
                                  .contains(unSelectedTriggers[idx]),
                            );
                          },
                          separatorBuilder: (_, idx) => SizedBox(height: 12.h),
                          itemCount: cards.length),
                      SizedBox(height: 20.h),
                      Align(
                        child: DefaultTextButton(
                          onPressed: tempSelected.isNotEmpty
                              ? () {
                                  triggers.addAll(tempSelected);
                                  final newTriggers = triggers.toSet();

                                  ref
                                      .read(actionCategoryProvider.notifier)
                                      .update((t) => newTriggers);
                                  context.pop();
                                }
                              : null,
                          text: "선택 완료",
                          able: tempSelected.isNotEmpty,
                        ),
                      ),
                      SizedBox(height: 20.h),
                    ],
                  ),
                );
              });
            });
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final visibleDelete = ref.watch(showFlowDeleteProvider(property));
    final triggers = property == FlowProperty.trigger
        ? ref.watch(triggerCategoryProvider)
        : ref.watch(actionCategoryProvider);

    late final List<_FlowInitCard> cards;

    if (property == FlowProperty.trigger) {
      triggers as Set<TriggerCategoryType>;
      cards = triggers
          .map((t) => _FlowInitCard(
                triggerType: t,
                onTap: () {
                  if (TriggerCategoryType.time == t) {
                    context.pushNamed(TimeTriggerScreen.routeName);
                  } else if (TriggerCategoryType.transfer == t) {
                    context.pushNamed(AccountTriggerScreen.routeName);
                  } else if (TriggerCategoryType.exchange == t) {
                    context.pushNamed(ExchangeTriggerScreen.routeName);
                  } else {
                    context.pushNamed(ProductTriggerScreen.routeName);
                  }
                },
                visibleDelete: visibleDelete,
              ))
          .toList();
    } else {
      triggers as Set<ActionCategoryType>;
      cards = triggers
          .map((t) => _FlowInitCard(
                actionType: t,
                onTap: () {
                  if (ActionCategoryType.notification == t) {
                    context.pushNamed(ActionNotificationScreen.routeName);
                  } else if (ActionCategoryType.exchange == t) {
                  } else {}
                },
                visibleDelete: visibleDelete,
              ))
          .toList();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              property == FlowProperty.trigger ? '조건' : '행동',
              style: SHFlowTextStyle.subTitle,
            ),
            InkWell(
              onTap: () {
                ref
                    .read(showFlowDeleteProvider(property).notifier)
                    .update((s) => !s);
              },
              child: Icon(
                Icons.delete,
                color: visibleDelete ? const Color(0xFF0057FF) : Colors.black,
              ),
            )
          ],
        ),
        SizedBox(height: 12.h),
        ListView.separated(
          padding: EdgeInsets.zero,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (_, idx) => cards[idx],
          separatorBuilder: (_, idx) => SizedBox(height: 12.h),
          itemCount: cards.length,
        ),
        if (cards.length != 4 && property == FlowProperty.trigger)
          getTriggerAddBtn(context, triggers as Set<TriggerCategoryType>, ref),
        if (cards.length != 3 && property == FlowProperty.action)
          getActionAddBtn(context, triggers as Set<ActionCategoryType>, ref)
      ],
    );
  }
}

class _FlowInitCard extends ConsumerWidget {
  final VoidCallback onTap;
  final TriggerCategoryType? triggerType;
  final ActionCategoryType? actionType;
  final bool visibleDelete;
  final bool isSelected;

  const _FlowInitCard(
      {super.key,
      this.triggerType,
      this.actionType,
      required this.onTap,
      this.isSelected = false,
      this.visibleDelete = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String content = triggerType != null
        ? '${triggerType!.name} 조건 선택'
        : '${actionType!.name} 하기';
    if (triggerType == TriggerCategoryType.time) {
      final triggers = ref.watch(flowFormProvider.select((f) => f.triggers));
      try {
        final findTrigger = triggers.singleWhere((t) => t.type.isTimeType());
        final param = (findTrigger as TgDateTimeParam);

        switch (findTrigger.type) {
          case TriggerType.specificDate:
            content = "${param.date}";
            break;
          case TriggerType.periodDate:
            content = "${param.startDate}부터\n${param.endDate}까지";
            break;
          case TriggerType.dayOfWeek:
            final dayOfWeek = param.dayOfWeek
                ?.map((d) => d.name)
                .reduce((v, e) => "$v, ${e}");
            content = "매주 $dayOfWeek 반복";
            break;
          case TriggerType.dayOfMonth:
            final dayOfWeek = param.dayOfMonth
                ?.map((d) => d.toString())
                .reduce((v, e) => "$v, $e");
            content = "매월 $dayOfWeek일 반복";
            break;
          default:
            break;
        }
      } on Error catch (e) {
        log("Error ${e}");
      }
    } else if (triggerType == TriggerCategoryType.product) {
      final triggers = ref.watch(flowFormProvider.select((f) => f.triggers));
      try {
        final findTrigger =
            triggers.singleWhere((t) => t.type == TriggerType.interestRate);
        final param = (findTrigger as TgProductParam);
        if (param.product != null) {
          content = "${param.product!.name} 금리 ${param.interestRate}%";
        }
      } on Error catch (e) {
        log("Error ${e}");
      }
    } else if (triggerType == TriggerCategoryType.exchange) {
      final triggers = ref.watch(flowFormProvider.select((f) => f.triggers));
      try {
        final findTrigger =
            triggers.singleWhere((t) => t.type == TriggerType.exchangeRate);
        final param = (findTrigger as TgExchangeParam);
        if (param.currency != null) {
          content = "${param.currency!.displayName}가 ${param.exRate} 이하";
        }
      } on Error catch (e) {
        log("Error ${e}");
      }
    } else if (triggerType == TriggerCategoryType.transfer) {
      final triggers = ref.watch(flowFormProvider.select((f) => f.triggers));
      try {
        final findTrigger = triggers.singleWhere((t) => t.type.isAccountType());

        switch (findTrigger.type) {
          case TriggerType.balance:
            final param = (findTrigger as TgAccountBalanceParam);
            content =
                '${param.account} ${param.balance}원 ${param.condition.name}';
            break;
          case TriggerType.deposit:
            final param = (findTrigger as TgAccountDepositParam);
            content = '${param.account} ${param.amount}원';

            break;
          case TriggerType.transfer:
            final param = (findTrigger as TgAccountTransferParam);
            content =
                '${param.fromAccount} ${param.toAccount} ${param.amount}원';

            break;
          case TriggerType.withdraw:
            final param = (findTrigger as TgAccountWithdrawParam);
            content = '${param.account} ${param.amount}원';
            break;
          default:
            break;
        }
      } on Error catch (e) {
        log("Error ${e}");
      }
    }

    if (actionType == ActionCategoryType.notification) {
      final actions = ref.watch(flowFormProvider.select((f) => f.actions));
      try {
        final findAction =
            actions.singleWhere((t) => t.type.isNotificationType());
        if (findAction.type == ActionType.balanceNotification) {
          final param = (findAction as AcBalanceNotificationParam);
          if (param.account.isNotEmpty) {
            content = "계좌번호 ${param.account} 잔액 알림";
          }
        } else if (findAction.type == ActionType.exchangeRateNotification) {
          final param = (findAction as AcExchangeRateNotificationParam);
          content = '${param.currency.displayName} 환전 알림';
        } else if (findAction.type == ActionType.textNotification) {
          final param = (findAction as AcTextNotificationParam);
          content = '${param.text} 알림';
        }
      } on Error catch (e) {
        log("Error ${e}");
      }
    }

    return ConstrainedBox(
      constraints: BoxConstraints.tight(Size(double.infinity, 100.h)),
      child: Stack(
        children: [
          Positioned(
            right: 0,
            left: 0,
            bottom: 0,
            child: InkWell(
              onTap: onTap,
              child: Align(
                child: Container(
                  width: double.infinity,
                  height: 90.h,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.r),
                      color: isSelected
                          ? const Color(0xFF0057FF)
                          : const Color(0xFFa3c9ff)),
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Text(
                    content,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: SHFlowTextStyle.subTitle.copyWith(
                        color: isSelected ? Colors.white : Colors.black),
                  ),
                ),
              ),
            ),
          ),
          Visibility(
            visible: visibleDelete,
            child: Positioned(
              top: 0,
              right: 0,
              child: Consumer(
                builder: (BuildContext context, WidgetRef ref, Widget? child) {
                  return InkWell(
                    onTap: () {
                      if (triggerType != null) {
                        final triggers = ref.read(triggerCategoryProvider);
                        triggers.remove(triggerType);
                        ref
                            .read(triggerCategoryProvider.notifier)
                            .update((t) => triggers.toSet());
                      } else {
                        final triggers = ref.read(actionCategoryProvider);
                        triggers.remove(actionType);
                        ref
                            .read(actionCategoryProvider.notifier)
                            .update((t) => triggers.toSet());
                      }
                    },
                    child: child!,
                  );
                },
                child: Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.25),
                            offset: Offset(2.r, 2.r),
                          )
                        ]),
                    child: const Icon(Icons.close)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AddButton extends StatelessWidget {
  final VoidCallback onTap;

  const _AddButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 58.h,
        margin: EdgeInsets.symmetric(vertical: 12.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.r),
          color: const Color(0xFFededed),
        ),
        child: Icon(
          Icons.add,
          size: 32.r,
        ),
      ),
    );
  }
}
