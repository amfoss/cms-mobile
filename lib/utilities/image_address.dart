class ImageAddressProvider {
  static String imageAddress(String url, String amfossPic) {
    if (amfossPic.isNotEmpty) {
      return "https://api.amfoss.in/" + amfossPic;
    } else {
      return "https://avatars.githubusercontent.com/" + url;
    }
  }
}