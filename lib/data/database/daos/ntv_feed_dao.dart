import 'package:floor/floor.dart';

import '../entities/ntv_feed_item.dart';

@dao
abstract class NtvFeedDao {
  @Query('SELECT * FROM NtvFeedItem ORDER BY createdAt DESC')
  Future<List<NtvFeedItem>> findAllNtvFeedItems();

  @Query('SELECT * FROM NtvFeedItem ORDER BY createdAt DESC')
  Stream<List<NtvFeedItem>> watchAllNtvFeedItems();

  @Query('SELECT * FROM NtvFeedItem WHERE link = :link LIMIT 1')
  Future<NtvFeedItem?> findNtvFeedItemByLink(String link);

  @Query(
    'SELECT * FROM NtvFeedItem WHERE isFavorite = 1 ORDER BY createdAt DESC',
  )
  Future<List<NtvFeedItem>> findFavoriteNtvFeedItems();

  @Query('SELECT * FROM NtvFeedItem WHERE isRead = 0 ORDER BY createdAt DESC')
  Future<List<NtvFeedItem>> findUnreadNtvFeedItems();

  @Query(
    'SELECT * FROM NtvFeedItem WHERE category = :category ORDER BY createdAt DESC',
  )
  Future<List<NtvFeedItem>> findNtvFeedItemsByCategory(String category);

  @Query(
    'SELECT * FROM NtvFeedItem WHERE title LIKE :query OR spot LIKE :query OR description LIKE :query ORDER BY createdAt DESC',
  )
  Future<List<NtvFeedItem>> searchNtvFeedItems(String query);

  @Query('SELECT COUNT(*) FROM NtvFeedItem')
  Future<int?> getItemCount();

  @Insert(onConflict: OnConflictStrategy.ignore)
  Future<int> insertNtvFeedItem(NtvFeedItem item);

  @Insert(onConflict: OnConflictStrategy.ignore)
  Future<List<int>> insertNtvFeedItems(List<NtvFeedItem> items);

  @update
  Future<int> updateNtvFeedItem(NtvFeedItem item);

  @delete
  Future<int> deleteNtvFeedItem(NtvFeedItem item);

  @Query(
    'DELETE FROM NtvFeedItem WHERE isFavorite = 0 AND createdAt < :cutoffTimestamp',
  )
  Future<void> deleteOldUnsavedItems(int cutoffTimestamp);

  @Query('DELETE FROM NtvFeedItem WHERE link = :link')
  Future<void> deleteNtvFeedItemByLink(String link);

  @Query('DELETE FROM NtvFeedItem')
  Future<void> deleteAllNtvFeedItems();
}
