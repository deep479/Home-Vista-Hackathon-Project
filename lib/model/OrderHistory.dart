// ignore_for_file: file_names

class OrderHistory {
  String? id;
  String? status;
  String? orderDate;
  String? total;
  String? tax;
  String? subtotal;
  String? transId;
  String? convFee;
  String? tip;
  String? couId;
  String? couAmt;
  String? wallAmt;
  String? commentReject;
  String? paymentTitle;
  String? paymentImg;
  String? jobStart;
  String? jobEnd;
  String? storeMobile;
  String? customerAddress;
  String? storeName;
  String? isRate;
  String? providerRate;
  String? providerText;
  String? riderRate;
  String? riderText;
  String? storeAddress;
  String? orderFlowId;
  String? lats;
  String? aStatus;
  String? longs;
  String? serviceDate;
  String? serviceTime;
  double? partnerRate;
  String? customerPmobile;
  String? distance;
  String? riderName;
  String? riderMobile;
  String? riderImg;
  dynamic totalDiscount;
  List<OrderProductData>? orderProductData;

  OrderHistory(
      {this.id,
      this.status,
      this.orderDate,
      this.total,
      this.tax,
      this.subtotal,
      this.transId,
      this.convFee,
      this.tip,
      this.couId,
      this.couAmt,
      this.wallAmt,
      this.commentReject,
      this.paymentTitle,
      this.paymentImg,
      this.jobStart,
      this.jobEnd,
      this.storeMobile,
      this.customerAddress,
      this.storeName,
      this.isRate,
      this.providerRate,
      this.providerText,
      this.riderRate,
      this.riderText,
      this.storeAddress,
      this.orderFlowId,
      this.lats,
      this.aStatus,
      this.longs,
      this.serviceDate,
      this.serviceTime,
      this.partnerRate,
      this.customerPmobile,
      this.distance,
      this.riderName,
      this.riderMobile,
      this.riderImg,
      this.totalDiscount,
      this.orderProductData});

  OrderHistory.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    status = json['status'];
    orderDate = json['order_date'];
    total = json['total'];
    tax = json['tax'];
    subtotal = json['subtotal'];
    transId = json['trans_id'];
    convFee = json['conv_fee'];
    tip = json['tip'];
    couId = json['cou_id'];
    couAmt = json['cou_amt'];
    wallAmt = json['wall_amt'];
    commentReject = json['comment_reject'];
    paymentTitle = json['payment_title'];
    paymentImg = json['payment_img'];
    jobStart = json['job_start'];
    jobEnd = json['job_end'];
    storeMobile = json['store_mobile'];
    customerAddress = json['customer_address'];
    storeName = json['store_name'];
    isRate = json['is_rate'];
    providerRate = json['provider_rate'];
    providerText = json['provider_text'];
    riderRate = json['rider_rate'];
    riderText = json['rider_text'];
    storeAddress = json['store_address'];
    orderFlowId = json['order_flow_id'];
    lats = json['lats'];
    aStatus = json['a_status'];
    longs = json['longs'];
    serviceDate = json['service_date'];
    serviceTime = json['service_time'];
    partnerRate = json['partner_rate'];
    customerPmobile = json['customer_pmobile'];
    distance = json['distance'];
    riderName = json['rider_name'];
    riderMobile = json['rider_mobile'];
    riderImg = json['rider_img'];
    totalDiscount = json['total_discount'];
    if (json['Order_Product_Data'] != null) {
      orderProductData = <OrderProductData>[];
      json['Order_Product_Data'].forEach((v) {
        orderProductData!.add(OrderProductData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['status'] = status;
    data['order_date'] = orderDate;
    data['total'] = total;
    data['tax'] = tax;
    data['subtotal'] = subtotal;
    data['trans_id'] = transId;
    data['conv_fee'] = convFee;
    data['tip'] = tip;
    data['cou_id'] = couId;
    data['cou_amt'] = couAmt;
    data['wall_amt'] = wallAmt;
    data['comment_reject'] = commentReject;
    data['payment_title'] = paymentTitle;
    data['payment_img'] = paymentImg;
    data['job_start'] = jobStart;
    data['job_end'] = jobEnd;
    data['store_mobile'] = storeMobile;
    data['customer_address'] = customerAddress;
    data['store_name'] = storeName;
    data['is_rate'] = isRate;
    data['provider_rate'] = providerRate;
    data['provider_text'] = providerText;
    data['rider_rate'] = riderRate;
    data['rider_text'] = riderText;
    data['store_address'] = storeAddress;
    data['order_flow_id'] = orderFlowId;
    data['lats'] = lats;
    data['a_status'] = aStatus;
    data['longs'] = longs;
    data['service_date'] = serviceDate;
    data['service_time'] = serviceTime;
    data['partner_rate'] = partnerRate;
    data['customer_pmobile'] = customerPmobile;
    data['distance'] = distance;
    data['rider_name'] = riderName;
    data['rider_mobile'] = riderMobile;
    data['rider_img'] = riderImg;
    data['total_discount'] = totalDiscount;
    if (orderProductData != null) {
      data['Order_Product_Data'] =
          orderProductData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class OrderProductData {
  String? productQuantity;
  String? productName;
  String? productImage;
  String? productDiscount;
  String? productPrice;
  dynamic productTotal;

  OrderProductData(
      {this.productQuantity,
      this.productName,
      this.productImage,
      this.productDiscount,
      this.productPrice,
      this.productTotal});

  OrderProductData.fromJson(Map<String, dynamic> json) {
    productQuantity = json['Product_quantity'];
    productName = json['Product_name'];
    productImage = json['Product_image'];
    productDiscount = json['Product_discount'];
    productPrice = json['Product_price'];
    productTotal = json['Product_total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Product_quantity'] = productQuantity;
    data['Product_name'] = productName;
    data['Product_image'] = productImage;
    data['Product_discount'] = productDiscount;
    data['Product_price'] = productPrice;
    data['Product_total'] = productTotal;
    return data;
  }
}
