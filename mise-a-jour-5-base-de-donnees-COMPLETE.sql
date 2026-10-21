-- Kouma : mise à jour de la base de données.
-- Avant d'importer : dans phpMyAdmin, cliquez sur le nom de votre base dans la colonne de gauche, puis sur l'onglet Importer.
-- Ce fichier ne s'importe qu'une fois : les tables n'existent pas encore.

-- 2026_10_02_000010_create_analytics_tables
create table `analytics_sessions` (`id` bigint unsigned not null auto_increment primary key, `session_key` varchar(32) not null, `visitor_key` varchar(32) not null, `user_id` bigint unsigned null, `workspace_id` bigint unsigned null, `audience` varchar(10) not null default 'visitor', `started_at` timestamp not null, `last_seen_at` timestamp not null, `date` date not null, `hour` tinyint unsigned not null, `dow` tinyint unsigned not null, `duration_seconds` int unsigned not null default '0', `pageviews` smallint unsigned not null default '0', `events` smallint unsigned not null default '0', `is_bounce` tinyint(1) not null default '1', `is_new` tinyint(1) not null default '1', `is_pwa` tinyint(1) not null default '0', `entry_path` varchar(255) null, `exit_path` varchar(255) null, `source` varchar(12) not null default 'direct', `referrer_host` varchar(120) null, `utm_source` varchar(80) null, `utm_medium` varchar(80) null, `utm_campaign` varchar(80) null, `device` varchar(10) not null default 'desktop', `browser` varchar(30) null, `os` varchar(30) null, `language` varchar(10) null, `timezone` varchar(50) null, `country` varchar(2) null, `created_at` timestamp null, `updated_at` timestamp null) default character set utf8mb4 collate 'utf8mb4_unicode_ci';
alter table `analytics_sessions` add index `analytics_sessions_date_audience_index`(`date`, `audience`);
alter table `analytics_sessions` add unique `analytics_sessions_session_key_unique`(`session_key`);
alter table `analytics_sessions` add index `analytics_sessions_visitor_key_index`(`visitor_key`);
alter table `analytics_sessions` add index `analytics_sessions_user_id_index`(`user_id`);
alter table `analytics_sessions` add index `analytics_sessions_workspace_id_index`(`workspace_id`);
alter table `analytics_sessions` add index `analytics_sessions_started_at_index`(`started_at`);
alter table `analytics_sessions` add index `analytics_sessions_date_index`(`date`);
create table `analytics_events` (`id` bigint unsigned not null auto_increment primary key, `session_id` bigint unsigned null, `visitor_key` varchar(32) not null, `user_id` bigint unsigned null, `workspace_id` bigint unsigned null, `audience` varchar(10) not null default 'visitor', `type` varchar(16) not null, `name` varchar(140) null, `path` varchar(255) null, `target` varchar(255) null, `value` int null, `cta` tinyint(1) not null default '0', `props` json null, `date` date not null, `hour` tinyint unsigned not null, `dow` tinyint unsigned not null, `created_at` timestamp not null) default character set utf8mb4 collate 'utf8mb4_unicode_ci';
alter table `analytics_events` add index `analytics_events_date_type_index`(`date`, `type`);
alter table `analytics_events` add index `analytics_events_session_id_index`(`session_id`);
alter table `analytics_events` add index `analytics_events_visitor_key_index`(`visitor_key`);
alter table `analytics_events` add index `analytics_events_user_id_index`(`user_id`);
alter table `analytics_events` add index `analytics_events_workspace_id_index`(`workspace_id`);
alter table `analytics_events` add index `analytics_events_created_at_index`(`created_at`);

-- 2026_10_03_000020_create_notification_tables
create table `push_subscriptions` (`id` bigint unsigned not null auto_increment primary key, `user_id` bigint unsigned not null, `workspace_id` bigint unsigned null, `endpoint_hash` varchar(64) not null, `endpoint` text not null, `p256dh` varchar(120) not null, `auth` varchar(40) not null, `platform` varchar(12) not null default 'other', `user_agent` varchar(255) null, `standalone` tinyint(1) not null default '0', `failures` tinyint unsigned not null default '0', `last_success_at` timestamp null, `last_failure_at` timestamp null, `created_at` timestamp null, `updated_at` timestamp null) default character set utf8mb4 collate 'utf8mb4_unicode_ci';
alter table `push_subscriptions` add index `push_subscriptions_user_id_index`(`user_id`);
alter table `push_subscriptions` add index `push_subscriptions_workspace_id_index`(`workspace_id`);
alter table `push_subscriptions` add unique `push_subscriptions_endpoint_hash_unique`(`endpoint_hash`);
create table `push_campaigns` (`id` bigint unsigned not null auto_increment primary key, `created_by` bigint unsigned null, `title` varchar(80) not null, `body` varchar(240) not null, `url` varchar(255) null, `kind` varchar(12) not null default 'promo', `audience` json not null, `also_email` tinyint(1) not null default '0', `status` varchar(12) not null default 'draft', `scheduled_at` timestamp null, `started_at` timestamp null, `finished_at` timestamp null, `cursor_user_id` bigint unsigned not null default '0', `targeted` int unsigned not null default '0', `notified` int unsigned not null default '0', `pushed` int unsigned not null default '0', `failed` int unsigned not null default '0', `skipped` int unsigned not null default '0', `deferred` int unsigned not null default '0', `emailed` int unsigned not null default '0', `created_at` timestamp null, `updated_at` timestamp null) default character set utf8mb4 collate 'utf8mb4_unicode_ci';
alter table `push_campaigns` add index `push_campaigns_created_by_index`(`created_by`);
alter table `push_campaigns` add index `push_campaigns_status_index`(`status`);
alter table `push_campaigns` add index `push_campaigns_scheduled_at_index`(`scheduled_at`);
create table `app_notifications` (`id` bigint unsigned not null auto_increment primary key, `user_id` bigint unsigned not null, `workspace_id` bigint unsigned null, `category` varchar(16) not null, `title` varchar(120) not null, `body` varchar(300) null, `url` varchar(255) null, `campaign_id` bigint unsigned null, `tag` varchar(60) null, `data` json null, `read_at` timestamp null, `push_after` timestamp null, `pushed_at` timestamp null, `created_at` timestamp not null default CURRENT_TIMESTAMP) default character set utf8mb4 collate 'utf8mb4_unicode_ci';
alter table `app_notifications` add index `app_notifications_user_id_read_at_index`(`user_id`, `read_at`);
alter table `app_notifications` add index `app_notifications_user_id_index`(`user_id`);
alter table `app_notifications` add index `app_notifications_workspace_id_index`(`workspace_id`);
alter table `app_notifications` add index `app_notifications_category_index`(`category`);
alter table `app_notifications` add index `app_notifications_campaign_id_index`(`campaign_id`);
alter table `app_notifications` add index `app_notifications_push_after_index`(`push_after`);
alter table `app_notifications` add index `app_notifications_created_at_index`(`created_at`);
alter table `users` add `notification_prefs` json null;

-- 2026_10_04_000030_create_conversation_notes
create table `conversation_notes` (`id` bigint unsigned not null auto_increment primary key, `conversation_id` bigint unsigned not null, `user_id` bigint unsigned null, `kind` varchar(10) not null default 'note', `body` text null, `meta` json null, `created_at` timestamp not null default CURRENT_TIMESTAMP) default character set utf8mb4 collate 'utf8mb4_unicode_ci';
alter table `conversation_notes` add index `conversation_notes_conversation_id_kind_index`(`conversation_id`, `kind`);
alter table `conversation_notes` add index `conversation_notes_conversation_id_index`(`conversation_id`);
alter table `conversation_notes` add index `conversation_notes_user_id_index`(`user_id`);
alter table `conversations` add index `conversations_last_message_at_index`(`last_message_at`);

-- Enregistrer les migrations comme faites (pour que « php artisan migrate » ne les rejoue pas).
set @lot := (select coalesce(max(batch), 0) + 1 from migrations);
insert into migrations (migration, batch) values ('2026_10_02_000010_create_analytics_tables', @lot);
insert into migrations (migration, batch) values ('2026_10_03_000020_create_notification_tables', @lot);
insert into migrations (migration, batch) values ('2026_10_04_000030_create_conversation_notes', @lot);
