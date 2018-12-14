# FlickrImageSearch

Search the Flickr images and display on the UICollectionView based on the query you are passing.

## Requirements

- XCode 9.4 or above
- Swift 4.2

## Flickr API Documentation

Photos are fetched from the [Flickr API](https://www.flickr.com/services/api/flickr.photos.search.html).

- **Search Path:**

```
https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=YOUR_FLICKR_API_KEY&format=json&nojsoncallback=1&safe_search=1&text=hello
```

- Below is the response for the Flickr API call

``` swift
{
"id": "23451156376",
"owner": "28017113@N08",
"secret": "8983a8ebc7",
"server": "578",
"farm": 1,
"title": "Merry Christmas!",
"ispublic": 1,
"isfriend": 0,
"isfamily": 0
}
```

### To load the photo, you can build the full URL following this pattern:
```
http://farm{farm}.static.flickr.com/{server}/{id}_{secret}.jpg
```
### Thus, using our Flickr photo model example above, the full URL would be:
```
http://farm1.static.flickr.com/578/23451156376_8983a8ebc7.jpg
```
### Generate your own here:
```
https://www.flickr.com/services/api/misc.api_keys.html
```
