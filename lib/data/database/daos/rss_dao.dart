import 'package:floor/floor.dart';

import '../entities/rss_item.dart';

@dao
abstract class RssDao {
  @Query('SELECT * FROM RssItem ORDER BY createdAt DESC')
  Future<List<RssItem>> findAllRssItems();

  @Query('SELECT * FROM RssItem ORDER BY createdAt DESC')
  Stream<List<RssItem>> watchAllRssItems();

  @Query('SELECT * FROM RssItem WHERE id = :id')
  Future<RssItem?> findRssItemById(int id);

  @Query('SELECT * FROM RssItem WHERE link = :link LIMIT 1')
  Future<RssItem?> findRssItemByLink(String link);

  @Query('SELECT * FROM RssItem WHERE isFavorite = 1 ORDER BY createdAt DESC')
  Future<List<RssItem>> findFavoriteRssItems();

  @Query('SELECT * FROM RssItem WHERE isRead = 0 ORDER BY createdAt DESC')
  Future<List<RssItem>> findUnreadRssItems();

  @Query(
    'SELECT * FROM RssItem WHERE title LIKE :query OR description LIKE :query ORDER BY createdAt DESC',
  )
  Future<List<RssItem>> searchRssItems(String query);

  @Query('SELECT COUNT(*) FROM RssItem')
  Future<int?> getItemCount();

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<int> insertRssItem(RssItem item);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<List<int>> insertRssItems(List<RssItem> items);

  @update
  Future<int> updateRssItem(RssItem item);

  @delete
  Future<int> deleteRssItem(RssItem item);

  @Query(
    'DELETE FROM RssItem WHERE isFavorite = 0 AND createdAt < :cutoffTimestamp',
  )
  Future<void> deleteOldUnsavedItems(int cutoffTimestamp);

  @Query('DELETE FROM RssItem WHERE id = :id')
  Future<void> deleteRssItemById(int id);

  @Query('DELETE FROM RssItem')
  Future<void> deleteAllRssItems();
}
