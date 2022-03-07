/// Returns a [Map] containing key 'authorization'
/// and value 'bearer [bearerToken]'
Map<String, String> createAuthMetadata(String bearerToken) {
  return {'authorization': 'bearer $bearerToken'};
}
