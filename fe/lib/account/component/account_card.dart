import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../theme/text_theme.dart';
import '../model/account_model.dart';
import '../model/account_transaction_history_model.dart';

class AccountCard extends StatelessWidget {
  final String bankCode;
  final String bankName;
  final String userName;
  final String accountNo;
  final String accountName;
  final String accountTypeCode;
  final String accountTypeName;
  final String accountCreatedDate;
  final String accountExpiryDate;
  final String dailyTransferLimit;
  final String oneTimeTransferLimit;
  final String accountBalance;
  final String lastTransactionDate;
  final String currency;

  const AccountCard(
      {super.key,
      required this.bankCode,
      required this.bankName,
      required this.userName,
      required this.accountNo,
      required this.accountName,
      required this.accountTypeCode,
      required this.accountTypeName,
      required this.accountCreatedDate,
      required this.accountExpiryDate,
      required this.dailyTransferLimit,
      required this.oneTimeTransferLimit,
      required this.accountBalance,
      required this.lastTransactionDate,
      required this.currency});

  factory AccountCard.fromModel({required AccountDetailModel model}) {
    return AccountCard(
      bankCode: model.bankCode,
      bankName: model.bankName,
      userName: model.userName,
      accountNo: model.accountNo,
      accountName: model.accountName,
      accountTypeCode: model.accountTypeCode,
      accountTypeName: model.accountTypeName,
      accountCreatedDate: model.accountCreatedDate,
      accountExpiryDate: model.accountExpiryDate,
      dailyTransferLimit: model.dailyTransferLimit,
      oneTimeTransferLimit: model.oneTimeTransferLimit,
      accountBalance: model.accountBalance,
      lastTransactionDate: model.lastTransactionDate,
      currency: model.currency,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150.h,
      padding: EdgeInsets.all(18.r),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.r),
          color: const Color(0xFF3F73FF)),
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      accountTypeName,
                      style: SHFlowTextStyle.subTitle.copyWith(
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      bankName,
                      style: SHFlowTextStyle.subTitle.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      accountNo,
                      style: SHFlowTextStyle.subTitle.copyWith(
                        color: Colors.white,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.white),
                            borderRadius: BorderRadius.circular(8.r)),
                        padding: EdgeInsets.symmetric(
                            horizontal: 12.w, vertical: 4.h),
                        child: Text(
                          "이체",
                          style: SHFlowTextStyle.labelBold
                              .copyWith(color: Colors.white),
                        ),
                      ),
                    )
                  ],
                ),
                const Spacer(),
                Text(
                  "$accountBalance 원",
                  style: SHFlowTextStyle.subTitle.copyWith(
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.end,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class TransactionHistoryCard extends StatelessWidget {
  final int transactionUniqueNo;
  final String transactionDate;
  final String transactionTime;
  final String transactionType;
  final String transactionTypeName;
  final String transactionAccountNo;
  final int transactionBalance;
  final int transactionAfterBalance;
  final String transactionSummary;
  final String transactionMemo;

  const TransactionHistoryCard(
      {super.key,
      required this.transactionUniqueNo,
      required this.transactionDate,
      required this.transactionTime,
      required this.transactionType,
      required this.transactionTypeName,
      required this.transactionAccountNo,
      required this.transactionBalance,
      required this.transactionAfterBalance,
      required this.transactionSummary,
      required this.transactionMemo});

  factory TransactionHistoryCard.fromModel(
      {required AccountTransactionHistoryModel model}) {
    return TransactionHistoryCard(
      transactionUniqueNo: model.transactionUniqueNo,
      transactionDate: model.transactionDate,
      transactionTime: model.transactionTime,
      transactionType: model.transactionType,
      transactionTypeName: model.transactionTypeName,
      transactionAccountNo: model.transactionAccountNo,
      transactionBalance: model.transactionBalance,
      transactionAfterBalance: model.transactionAfterBalance,
      transactionSummary: model.transactionSummary,
      transactionMemo: model.transactionMemo,
    );
  }

  @override
  Widget build(BuildContext context) {
    final textColor = transactionType == '1'
        ? const Color(0xFFE21A1A)
        : const Color(0xFF0057FF);
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(color: Color(0xFFAAAAAA)),
        ),
      ),
      padding: EdgeInsets.symmetric(vertical: 12.h),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  transactionTime,
                ),
                SizedBox(height: 30.h),
                Text(transactionDate)
              ],
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  transactionTypeName,
                  style: SHFlowTextStyle.label.copyWith(
                    color: textColor,
                  ),
                ),
                Text(
                  '$transactionBalance 원',
                  style: SHFlowTextStyle.labelBold.copyWith(
                    color: textColor,
                  ),
                ),
                Text('잔액 $transactionAfterBalance 원'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
