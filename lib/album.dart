import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:collection/collection.dart';

import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as parser;

Future<List<Album>> fetchAlbum(
    {urlText =
        "https://www.dmm.co.jp/mono/dvd/-/list/=/list_type=release/sort=date/"}) async {
  Uri url = Uri.parse(urlText);
  http.Request request = new http.Request("get", url);
  print("fetch from: $urlText");
  request.headers.addAll({
    'cookie':
        'notified_popup_id=,43; app_uid=Z/6RoWNOtPWHis7zCFkFAg==; __utmc=125690133; i3_ab=238d9db1-cb40-4a59-8286-5847a75ac190; _gcl_au=1.1.1963348065.1666102517; _cq_duid=1.1666102517.LcfTD4WBvxumwLa6; _cq_suid=1.1666102517.cMW8mnNpoHJxpIWt; _dga=GA1.3.1273009739.1666102517; age_check_done=1; adpf_uid=bChqhecDVfRaKWLZ; adr_id=Ogi0GiVjB61tFs0jYW7f6qTlqers588uvn4MFYelfKcIjyKQ; _im_vid=01GFNQ5WWEG3HYRMRWA81ZXCQC; _ts_yjad=1666102528878; bypass_auid=44e9b87a-18e5-0521-43c8-f6deeede1f88; __lt__cid=8b7393c3-3a82-44ef-a37f-2c3ea851b527; list_condition={"digital":{"limit":null,"sort":null,"view":null}}; LSS_SESID=A1lRXE9CCQJYQTR6d0cKEF9WAFkQOFQGCHhVCSQlcycjKS8Qf1lcBSMiIHJWRwoQX1EOQWE1JWJtFl1YX1UEVFRSUlQBBgYKEVlYCREpYjA6N3EweyVGC1gOVQseFwhbWEEOB0dFbEINERURCBYLVF9GRgJcCg1eXhZdQl9TCEAGCgUPQFBfE1kQWwQJR0MCCw9dDVVDX0MDAFwTEw1XFUBYEVwECxETWR4c; _gid=GA1.3.1728543874.1666931557; __utma=125690133.1273009739.1666102517.1666102517.1666931557.2; __utmz=125690133.1666931557.2.2.utmcsr=google|utmccn=(organic)|utmcmd=organic|utmctr=(not provided); _dga_gid=GA1.3.543980820.1666931558; guest_id=URFSVVRYUEJbEFJT; dmm_service=BFsBAx1FWwQCR1JXXlsJWUNeVwwBAx9KWFYNREEKRURHWkMDUgxDVlkRVBoISxs_; ckcy=1; _ga_G34HHM5C8N=GS1.1.1666931557.2.1.1666932144.0.0.0; _ga=GA1.1.1623927823.1666102518; _ga_SFMSWE0TVN=GS1.1.1666931557.2.1.1666932144.0.0.0; _dd_s=',
    'authority': 'www.dmm.co.jp',
    'accept':
        'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9',
  });
  final response = await request.send();
  final respStr = await response.stream.bytesToString();

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    var data = parser.parse(respStr);
    return parseFromHtml(data.outerHtml);
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}

Future<AlbumDetail> fetchAlbumDetail(albumUrl) async {
  Uri url = Uri.parse(albumUrl);
  http.Request request = new http.Request("get", url);

  request.headers.addAll({
    'cookie':
        'notified_popup_id=,43; app_uid=Z/6RoWNOtPWHis7zCFkFAg==; __utmc=125690133; i3_ab=238d9db1-cb40-4a59-8286-5847a75ac190; _gcl_au=1.1.1963348065.1666102517; _cq_duid=1.1666102517.LcfTD4WBvxumwLa6; _cq_suid=1.1666102517.cMW8mnNpoHJxpIWt; _dga=GA1.3.1273009739.1666102517; age_check_done=1; adpf_uid=bChqhecDVfRaKWLZ; adr_id=Ogi0GiVjB61tFs0jYW7f6qTlqers588uvn4MFYelfKcIjyKQ; _im_vid=01GFNQ5WWEG3HYRMRWA81ZXCQC; _ts_yjad=1666102528878; bypass_auid=44e9b87a-18e5-0521-43c8-f6deeede1f88; __lt__cid=8b7393c3-3a82-44ef-a37f-2c3ea851b527; list_condition={"digital":{"limit":null,"sort":null,"view":null}}; LSS_SESID=A1lRXE9CCQJYQTR6d0cKEF9WAFkQOFQGCHhVCSQlcycjKS8Qf1lcBSMiIHJWRwoQX1EOQWE1JWJtFl1YX1UEVFRSUlQBBgYKEVlYCREpYjA6N3EweyVGC1gOVQseFwhbWEEOB0dFbEINERURCBYLVF9GRgJcCg1eXhZdQl9TCEAGCgUPQFBfE1kQWwQJR0MCCw9dDVVDX0MDAFwTEw1XFUBYEVwECxETWR4c; _gid=GA1.3.1728543874.1666931557; __utma=125690133.1273009739.1666102517.1666102517.1666931557.2; __utmz=125690133.1666931557.2.2.utmcsr=google|utmccn=(organic)|utmcmd=organic|utmctr=(not provided); _dga_gid=GA1.3.543980820.1666931558; guest_id=URFSVVRYUEJbEFJT; dmm_service=BFsBAx1FWwQCR1JXXlsJWUNeVwwBAx9KWFYNREEKRURHWkMDUgxDVlkRVBoISxs_; ckcy=1; _ga_G34HHM5C8N=GS1.1.1666931557.2.1.1666932144.0.0.0; _ga=GA1.1.1623927823.1666102518; _ga_SFMSWE0TVN=GS1.1.1666931557.2.1.1666932144.0.0.0; _dd_s=',
    'authority': 'www.dmm.co.jp',
    'accept':
        'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9',
  });
  final response = await request.send();
  final respStr = await response.stream.bytesToString();

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    var data = parser.parse(respStr);
    return parseDetailFromHtml(data.outerHtml);
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}

List<Album> parseFromHtml(String outerHtml) {
  dom.Document html = dom.Document.html(outerHtml);
  var detailUrl = html
      .querySelectorAll('.tmb > a')
      .map((e) => e.attributes['href'])
      .toList();
  var thumbnailUrl = html
      .querySelectorAll('.tmb > a > span > img')
      .map((e) => ["https:", e.attributes['src']].join())
      .toList();

  List<Album> returnAlbum = [];
  for (final pairs in IterableZip([detailUrl, thumbnailUrl])) {
    returnAlbum.add(Album(pairs[0]!, pairs[1]!));
  }
  return returnAlbum;
}

AlbumDetail parseDetailFromHtml(String outerHtml) {
  dom.Document html = dom.Document.html(outerHtml);
  var coverUrl = html
      .querySelectorAll('[name=package-image]')
      .map((e) => e.attributes['href'])
      .first;
  var snapshotUrl = html
      .querySelectorAll('[name=sample-image] > img')
      .map((e) => e.attributes['src'].toString())
      .toList();

  snapshotUrl.removeAt(1);

  return AlbumDetail(coverUrl!, snapshotUrl);
}

class Album {
  final String url;
  final String thumbnail_url;

  const Album(
    this.url,
    this.thumbnail_url,
  );
}

class AlbumDetail {
  final String coverUrl;
  final List<String> snapshopUrl;

  const AlbumDetail(
    this.coverUrl,
    this.snapshopUrl,
  );
}

String snapshotHugeUrl(String snapshopUrl) {
  var parts = snapshopUrl.split('-');

  if (parts.length >= 2) {
    parts[parts.length - 2] = parts[parts.length - 2] + "jp";
  }
  return parts.join('-');
}

/* void main(List<String> args) {
  print(snapshotHugeUrl(
      ("https://pics.dmm.co.jp/digital/video/adn00432/adn004321.jpg")));
}
 */