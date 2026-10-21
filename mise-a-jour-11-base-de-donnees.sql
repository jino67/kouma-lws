-- Kouma : mise à jour de la base de données.
-- Avant d'importer : dans phpMyAdmin, cliquez sur le nom de votre base dans la colonne de gauche, puis sur l'onglet Importer.
-- Ce fichier ne s'importe qu'une fois : les tables n'existent pas encore.

-- 2026_10_06_000010_create_crawl_and_catalog
create table `source_pages` (`id` bigint unsigned not null auto_increment primary key, `workspace_id` bigint unsigned not null, `bot_id` bigint unsigned not null, `source_id` bigint unsigned not null, `url` text not null, `url_hash` char(40) not null, `status` varchar(12) not null default 'pending', `depth` tinyint unsigned not null default '0', `priority` tinyint unsigned not null default '4', `http_status` smallint unsigned null, `title` varchar(255) null, `content` longtext null, `content_hash` char(40) null, `products` json null, `note` varchar(120) null, `fetched_at` timestamp null, `created_at` timestamp null, `updated_at` timestamp null) default character set utf8mb4 collate 'utf8mb4_unicode_ci';
alter table `source_pages` add constraint `source_pages_workspace_id_foreign` foreign key (`workspace_id`) references `workspaces` (`id`) on delete cascade;
alter table `source_pages` add constraint `source_pages_bot_id_foreign` foreign key (`bot_id`) references `bots` (`id`) on delete cascade;
alter table `source_pages` add constraint `source_pages_source_id_foreign` foreign key (`source_id`) references `sources` (`id`) on delete cascade;
alter table `source_pages` add unique `source_pages_source_id_url_hash_unique`(`source_id`, `url_hash`);
alter table `source_pages` add index `source_pages_source_id_status_priority_depth_id_index`(`source_id`, `status`, `priority`, `depth`, `id`);
create table `catalog_items` (`id` bigint unsigned not null auto_increment primary key, `workspace_id` bigint unsigned not null, `bot_id` bigint unsigned not null, `source_id` bigint unsigned null, `item_key` char(40) not null, `name` varchar(160) not null, `category` varchar(80) null, `price_text` varchar(80) null, `amount` decimal(14, 2) null, `currency` varchar(8) null, `availability` varchar(60) null, `description` text null, `url` text null, `image_url` text null, `image_path` varchar(255) null, `image_status` varchar(12) not null default 'none', `image_fetched_at` timestamp null, `times_shown` int unsigned not null default '0', `created_at` timestamp null, `updated_at` timestamp null) default character set utf8mb4 collate 'utf8mb4_unicode_ci';
alter table `catalog_items` add constraint `catalog_items_workspace_id_foreign` foreign key (`workspace_id`) references `workspaces` (`id`) on delete cascade;
alter table `catalog_items` add constraint `catalog_items_bot_id_foreign` foreign key (`bot_id`) references `bots` (`id`) on delete cascade;
alter table `catalog_items` add constraint `catalog_items_source_id_foreign` foreign key (`source_id`) references `sources` (`id`) on delete set null;
alter table `catalog_items` add unique `catalog_items_bot_id_item_key_unique`(`bot_id`, `item_key`);
alter table `sources` add `progress` json null after `stats`;

-- Enregistrer les migrations comme faites (pour que « php artisan migrate » ne les rejoue pas).
set @lot := (select coalesce(max(batch), 0) + 1 from migrations);
insert into migrations (migration, batch) values ('2026_10_06_000010_create_crawl_and_catalog', @lot);
