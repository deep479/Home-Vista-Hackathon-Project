// ignore_for_file: file_names, avoid_print

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ucservice_customer/AppScreens/Home/home_screen.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:ucservice_customer/utils/colors.dart';

import '../../ApiServices/Api_werper.dart';
import '../../ApiServices/url.dart';
import '../../payment/InputFormater.dart';
import '../../payment/PayPal.dart';
import '../../payment/Payment_card.dart';
import '../../payment/StripeWeb.dart';
import '../../utils/AppWidget.dart';
import '../../utils/color_widget.dart';
import 'WalletHistory.dart';

class AddWalletPage extends StatefulWidget {
  final String? amount;
  const AddWalletPage({Key? key, this.amount}) : super(key: key);

  @override
  State<AddWalletPage> createState() => _AddWalletPageState();
}

class _AddWalletPageState extends State<AddWalletPage> {
  late Razorpay _razorpay;

  final addAmount = TextEditingController();

  List walletitem = [];
  String? totalAmount = "0";
  int amount = 0;
  String? selectidpay = "1";
  int _groupValue = 0;
  String? paymenttital;
  String ticketType = "";

  String typeid = "";
  String razorpaykey = "";
  List paymentList = [];

  @override
  void initState() {
    paymentgateway();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    super.initState();
  }

  late ColorNotifire notifire;
  getdarkmodepreviousstate() async {
    final prefs = await SharedPreferences.getInstance();
    bool? previusstate = prefs.getBool("setIsDark");
    if (previusstate == null) {
      notifire.setIsDark = false;
    } else {
      notifire.setIsDark = previusstate;
    }
  }

  walletupdate() async {
    var data = {"uid": uid, "wallet": addAmount.text};

    ApiWrapper.dataPost(Config.walletup, data).then((val) {
      if ((val != null) && (val.isNotEmpty)) {
        if ((val['ResponseCode'] == "200") && (val['Result'] == "true")) {
          setState(() {});
          Get.back();
        } else {}
      }
    });
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    walletupdate();
    ApiWrapper.showToastMessage("Payment Successfully");
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    print(
        'Error Response: ${"ERROR: ${response.code} - ${response.message!}"}');
    ApiWrapper.showToastMessage(response.message!);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    ApiWrapper.showToastMessage(response.walletName!);
  }

  @override
  Widget build(BuildContext context) {
    notifire = Provider.of<ColorNotifire>(context, listen: true);
    Future.delayed(const Duration(seconds: 0), () {
      setState(() {});
    });
    return Scaffold(
      backgroundColor: notifire.getprimerycolor,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        leading: InkWell(
            onTap: () {
              Get.back();
            },
            child: Icon(Icons.arrow_back, color: notifire.getdarkscolor)),
        backgroundColor: notifire.getprimerycolor,
        title: Text("Add Wallet",
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: notifire.getdarkscolor)),
      ),
      floatingActionButton: SizedBox(
        height: 45,
        width: 410,
        child: FloatingActionButton(
          onPressed: () {
            FocusScope.of(context).requestFocus(FocusNode());
            if (addAmount.text.isNotEmpty) {
              paymentSheet();
            } else {
              ApiWrapper.showToastMessage("please enter amount");
            }
          },
          child: Custombutton.button(
              CustomColors.primaryColor,
              "Add".toUpperCase(),
              SizedBox(width: Get.width / 3),
              SizedBox(width: Get.width / 10)),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(left: Get.width * 0.03),
            child: Container(
              height: Get.height * 0.20,
              width: Get.width,
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/walletTop.png'),
                      fit: BoxFit.fill)),
              child: Padding(
                padding: EdgeInsets.only(left: Get.width * 0.04),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "$currency${widget.amount}",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Gilroy Bold',
                          color: Colors.white),
                    ),
                    const Text("Your current Balance ",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Gilroy Bold',
                            color: CustomColors.white)),
                    Container(height: Get.height * 0.04)
                  ],
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Text(
                "Add Amount",
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Gilroy Bold',
                    color: notifire.getdarkscolor),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Column(
              children: [
                SizedBox(height: Get.height * 0.02),
                Customtextfild.textField(
                  controller: addAmount,
                  name1: "Amount",
                  labelclr: Colors.grey,
                  textcolor: notifire.getdarkscolor,
                  keyboardType: TextInputType.number,
                  prefixIcon: InkWell(
                    child: Image.asset("assets/wallet.png",
                        scale: 3.5, color: notifire.getdarkscolor),
                    onTap: () {
                      setState(() {
                        amount = amount + 10;
                      });
                    },
                  ),
                ),
                SizedBox(height: Get.height * 0.03),
                Wrap(
                  children: [
                    amountRow(
                        title: "$currency" "100",
                        onTap: () {
                          setState(() {});
                          addAmount.text = "100";
                        }),
                    amountRow(
                        title: "$currency" "200",
                        onTap: () {
                          setState(() {});
                          addAmount.text = "200";
                        }),
                    amountRow(
                        title: "$currency" "300",
                        onTap: () {
                          setState(() {});
                          addAmount.text = "300";
                        }),
                    amountRow(
                        title: "$currency" "400",
                        onTap: () {
                          setState(() {});
                          addAmount.text = "400";
                        }),
                    amountRow(
                        title: "$currency" "500",
                        onTap: () {
                          setState(() {});
                          addAmount.text = "500";
                        }),
                    amountRow(
                        title: "$currency" "600",
                        onTap: () {
                          setState(() {});
                          addAmount.text = "600";
                        }),
                    amountRow(
                        title: "$currency" "700",
                        onTap: () {
                          setState(() {});
                          addAmount.text = "700";
                        }),
                    amountRow(
                        title: "$currency" "800",
                        onTap: () {
                          setState(() {});
                          addAmount.text = "800";
                        }),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  amountRow({Function()? onTap, String? title}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: Get.height * 0.045,
          width: Get.width * 0.20,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: notifire.greyfont, width: 1)),
          child: Center(
            child: Text(
              title ?? "",
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Gilroy Medium',
                  color: notifire.getdarkscolor),
            ),
          ),
        ),
      ),
    );
  }
  //!--------------- payment --------------------

  Future paymentSheet() {
    return showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: notifire.getprimerycolor,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      context: context,
      builder: (context) {
        return Wrap(
          children: [
            StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: Get.height / 60),
                  Center(
                    child: Container(
                      height: Get.height / 80,
                      width: Get.width / 5,
                      decoration: BoxDecoration(
                          color: notifire.greyfont,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(20))),
                    ),
                  ),
                  SizedBox(height: Get.height / 60),
                  Row(
                    children: [
                      SizedBox(width: Get.width / 14),
                      Text("Select Payment Method",
                          style: TextStyle(
                              color: notifire.getdarkscolor,
                              fontSize: Get.height / 40,
                              fontFamily: 'Gilroy_Bold')),
                    ],
                  ),
                  SizedBox(height: Get.height / 60),
                  //! --------- List view paymente ----------
                  SizedBox(
                    height: Get.height * 0.50,
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: paymentList.length,
                      itemBuilder: (ctx, i) {
                        return paymentList[i]["p_show"] != "0"
                            ? Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8),
                                child: sugestlocationtype(
                                  borderColor:
                                      selectidpay == paymentList[i]["id"]
                                          ? CustomColors.primaryColor
                                          : notifire.getdarkscolor,
                                  title: paymentList[i]["title"],
                                  titleColor: notifire.getdarkscolor,
                                  val: 0,
                                  image:
                                      Config.imgBaseUrl + paymentList[i]["img"],
                                  adress: paymentList[i]["subtitle"],
                                  ontap: () async {
                                    setState(() {
                                      razorpaykey =
                                          paymentList[i]["attributes"];
                                      paymenttital = paymentList[i]["title"];
                                      selectidpay = paymentList[i]["id"];
                                      _groupValue = i;
                                    });
                                  },
                                  radio: Radio(
                                    activeColor: CustomColors.primaryColor,
                                    value: i,
                                    groupValue: _groupValue,
                                    onChanged: (value) {
                                      setState(() {});
                                    },
                                  ),
                                ),
                              )
                            : const SizedBox();
                      },
                    ),
                  ),

                  SizedBox(height: Get.height / 30),
                  InkWell(
                      onTap: () {
                        //!---- Stripe Payment ------

                        if (paymenttital == "Stripe") {
                          Get.back();
                          stripePayment();
                        } else if (paymenttital == "Paypal") {
                          //!---- PayPal Payment ------
                          Get.to(() =>
                                  PayPalPayment(totalAmount: addAmount.text))!
                              .then((otid) {
                            if (otid != null) {
                              walletupdate();
                              ApiWrapper.showToastMessage(
                                  "Payment Successfully");
                            } else {
                              Get.back();
                            }
                          });
                        } else if (paymenttital == "Razorpay") {
                          //!---- Razorpay Payment ------
                          Get.back();
                          openCheckout();
                        }
                      },
                      child: paynowbutton()),
                  SizedBox(height: Get.height * 0.08),
                ],
              );
            }),
          ],
        );
      },
    );
  }

  Widget paynowbutton() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        height: Get.height / 16,
        width: Get.width / 1.1,
        decoration: BoxDecoration(
            color: CustomColors.primaryColor,
            borderRadius: BorderRadius.circular(12)),
        child: Center(
          child: Text(
              "PAY NOW | "
              "$currency${addAmount.text}",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: Get.height / 50,
                  fontFamily: 'Gilroy_Medium')),
        ),
      ),
    );
  }

  //!--------------------------- payment Widget --------------------
  final _formKey = GlobalKey<FormState>();
  var numberController = TextEditingController();
  final _paymentCard = PaymentCard();
  var _autoValidateMode = AutovalidateMode.disabled;
  bool isloading = false;

  final _card = PaymentCard();
  stripePayment() {
    return showModalBottomSheet(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        backgroundColor: Colors.white,
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Ink(
                  child: Column(children: [
                    SizedBox(height: Get.height / 45),
                    Center(
                      child: Container(
                        height: Get.height / 85,
                        width: Get.width / 5,
                        decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.4),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(20))),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(height: Get.height * 0.03),
                            const Text('Add Your payment information',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    letterSpacing: 0.5)),
                            SizedBox(height: Get.height * 0.02),
                            Form(
                                key: _formKey,
                                autovalidateMode: _autoValidateMode,
                                child: Column(children: [
                                  const SizedBox(height: 16),
                                  TextFormField(
                                      keyboardType: TextInputType.number,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly,
                                        LengthLimitingTextInputFormatter(19),
                                        CardNumberInputFormatter()
                                      ],
                                      controller: numberController,
                                      onSaved: (String? value) {
                                        _paymentCard.number =
                                            CardUtils.getCleanedNumber(value!);

                                        CardType cardType =
                                            CardUtils.getCardTypeFrmNumber(
                                                _paymentCard.number.toString());
                                        setState(() {
                                          _card.name = cardType.toString();
                                          _paymentCard.type = cardType;
                                        });
                                      },
                                      onChanged: (val) {
                                        CardType cardType =
                                            CardUtils.getCardTypeFrmNumber(val);
                                        setState(() {
                                          _card.name = cardType.toString();
                                          _paymentCard.type = cardType;
                                        });
                                      },
                                      validator: CardUtils.validateCardNum,
                                      decoration: InputDecoration(
                                          prefixIcon: SizedBox(
                                              height: 10,
                                              child: Padding(
                                                  padding: const EdgeInsets.symmetric(
                                                      vertical: 14,
                                                      horizontal: 6),
                                                  child: CardUtils.getCardIcon(
                                                      _paymentCard.type))),
                                          focusedErrorBorder: const OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: CustomColors
                                                      .primaryColor)),
                                          errorBorder: const OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: CustomColors
                                                      .primaryColor)),
                                          enabledBorder: const OutlineInputBorder(
                                              borderSide: BorderSide(color: CustomColors.primaryColor)),
                                          focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: CustomColors.primaryColor)),
                                          hintText: 'What number is written on card?',
                                          labelStyle: const TextStyle(color: CustomColors.primaryColor),
                                          labelText: 'Number')),
                                  const SizedBox(height: 20),
                                  Row(children: [
                                    Flexible(
                                      flex: 4,
                                      child: TextFormField(
                                        inputFormatters: [
                                          FilteringTextInputFormatter
                                              .digitsOnly,
                                          LengthLimitingTextInputFormatter(4),
                                        ],
                                        decoration: InputDecoration(
                                            prefixIcon: SizedBox(
                                                height: 10,
                                                child: Padding(
                                                    padding:
                                                        const EdgeInsets.symmetric(
                                                            vertical: 14),
                                                    child: Image.asset(
                                                        'assets/card_cvv.png',
                                                        width: 6,
                                                        color: CustomColors
                                                            .primaryColor))),
                                            focusedErrorBorder:
                                                const OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: CustomColors
                                                            .primaryColor)),
                                            errorBorder: const OutlineInputBorder(
                                                borderSide:
                                                    BorderSide(color: CustomColors.primaryColor)),
                                            enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: CustomColors.primaryColor)),
                                            focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: CustomColors.primaryColor)),
                                            hintText: 'Number behind the card',
                                            labelStyle: const TextStyle(color: CustomColors.primaryColor),
                                            labelText: 'CVV'),
                                        validator: CardUtils.validateCVV,
                                        keyboardType: TextInputType.number,
                                        onSaved: (value) {
                                          _paymentCard.cvv = int.parse(value!);
                                        },
                                      ),
                                    ),
                                    SizedBox(width: Get.width * 0.03),
                                    Flexible(
                                      flex: 4,
                                      child: TextFormField(
                                        inputFormatters: [
                                          FilteringTextInputFormatter
                                              .digitsOnly,
                                          LengthLimitingTextInputFormatter(4),
                                          CardMonthInputFormatter()
                                        ],
                                        decoration: InputDecoration(
                                            prefixIcon: SizedBox(
                                                height: 10,
                                                child: Padding(
                                                    padding: const EdgeInsets.symmetric(
                                                        vertical: 14),
                                                    child: Image.asset(
                                                        'assets/calender.png',
                                                        width: 10,
                                                        color: CustomColors
                                                            .primaryColor))),
                                            errorBorder: const OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: CustomColors
                                                        .primaryColor)),
                                            focusedErrorBorder: const OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: CustomColors.primaryColor)),
                                            enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: CustomColors.primaryColor)),
                                            focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: CustomColors.primaryColor)),
                                            hintText: 'MM/YY',
                                            labelStyle: const TextStyle(color: CustomColors.primaryColor),
                                            labelText: 'Expiry Date'),
                                        validator: CardUtils.validateDate,
                                        keyboardType: TextInputType.number,
                                        onSaved: (value) {
                                          List<int> expiryDate =
                                              CardUtils.getExpiryDate(value!);
                                          _paymentCard.month = expiryDate[0];
                                          _paymentCard.year = expiryDate[1];
                                        },
                                      ),
                                    )
                                  ]),
                                  SizedBox(height: Get.height * 0.055),
                                  Container(
                                      alignment: Alignment.center,
                                      child: _getPayButton()),
                                  SizedBox(height: Get.height * 0.065),
                                ]))
                          ]),
                    )
                  ]),
                ),
              ),
            );
          });
        });
  }

  @override
  void dispose() {
    numberController.removeListener(_getCardTypeFrmNumber);
    numberController.dispose();
    _razorpay.clear();
    super.dispose();
  }

  void _getCardTypeFrmNumber() {
    String input = CardUtils.getCleanedNumber(numberController.text);
    CardType cardType = CardUtils.getCardTypeFrmNumber(input);
    setState(() {
      _paymentCard.type = cardType;
    });
  }

  void _validateInputs() {
    final FormState form = _formKey.currentState!;
    if (!form.validate()) {
      setState(() {
        _autoValidateMode = AutovalidateMode.always;
      });
      _showInSnackBar('Please fix the errors in red before submitting.');
    } else {
      var username = getData.read("UserLogin")["name"] ?? "";
      var email = getData.read("UserLogin")["email"] ?? "";
      _paymentCard.name = username;
      _paymentCard.email = email;
      _paymentCard.amount = addAmount.text;
      form.save();

      Get.to(() => StripePaymentWeb(paymentCard: _paymentCard))!.then((otid) {
        Get.back();
        //! order Api call
        if (otid != null) {
          //! Api Call Payment Success
          walletupdate();
        }
      });

      _showInSnackBar('Payment card is valid');
    }
  }

  Widget _getPayButton() {
    return SizedBox(
      width: Get.width,
      child: CupertinoButton(
          onPressed: _validateInputs,
          color: CustomColors.primaryColor,
          child: Text("Pay $currency${addAmount.text}",
              style: const TextStyle(fontSize: 17.0))),
    );
  }

  void _showInSnackBar(String value) {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(value), duration: const Duration(seconds: 3)));
  }

  void openCheckout() async {
    var username = getData.read("UserLogin")["name"] ?? "";
    var mobile = getData.read("UserLogin")["mobile"] ?? "";
    var email = getData.read("UserLogin")["email"] ?? "";
    var options = {
      'key': razorpaykey,
      'amount': (double.parse(addAmount.text) * 100).toString(),
      'name': username,
      'description': ticketType,
      'timeout': 300,
      'prefill': {'contact': mobile, 'email': email},
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Error: e');
    }
  }

  //! user CountryCode
  paymentgateway() {
    ApiWrapper.dataGet(Config.paymentlist).then((val) {
      if ((val != null) && (val.isNotEmpty)) {
        if ((val['ResponseCode'] == "200") && (val['Result'] == "true")) {
          paymentList = val["paymentdata"];
          setState(() {});
        } else {
          ApiWrapper.showToastMessage(val["ResponseMsg"]);
        }
      }
    });
  }
}

class Customtextfild {
  static Widget textField({
    TextEditingController? controller,
    String? name1,
    Color? labelclr,
    Color? textcolor,
    Color? imagecolor,
    String? Function(String?)? validator,
    Widget? prefixIcon,
    Function(String)? onChanged,
    TextInputType? keyboardType,
    TextInputAction? textInputAction,
  }) {
    return Container(
      color: Colors.transparent,
      height: 45,
      child: TextFormField(
        controller: controller,
        onChanged: onChanged,
        validator: validator,
        textInputAction: textInputAction,
        keyboardType: keyboardType,
        style: TextStyle(color: textcolor),
        decoration: InputDecoration(
          disabledBorder:
              OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          labelText: name1,
          labelStyle: TextStyle(color: labelclr),
          prefixIcon: prefixIcon,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
              borderRadius: BorderRadius.circular(10)),
          focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Color(0xff5669FF), width: 1),
              borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }
}
