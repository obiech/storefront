const _customerServiceName = '/dropezy.v1.customer.CustomerService';

List<String> get authWhitelistedPaths {
  return ['Check', 'Register']
      .map(
        (uri) => '$_customerServiceName/$uri',
      )
      .toList();
}
