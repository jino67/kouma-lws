-- Kouma : mise à jour de la base de données.
-- Avant d'importer : dans phpMyAdmin, cliquez sur le nom de votre base dans la colonne de gauche, puis sur l'onglet Importer.
-- Ce fichier ne s'importe qu'une fois : les tables n'existent pas encore.

-- 2026_10_04_000030_create_conversation_notes
create table `conversation_notes` (`id` bigint unsigned not null auto_increment primary key, `conversation_id` bigint unsigned not null, `user_id` bigint unsigned null, `kind` varchar(10) not null default 'note', `body` text null, `meta` json null, `created_at` timestamp not null default CURRENT_TIMESTAMP) default character set utf8mb4 collate 'utf8mb4_unicode_ci';
alter table `conversation_notes` add index `conversation_notes_conversation_id_kind_index`(`conversation_id`, `kind`);
alter table `conversation_notes` add index `conversation_notes_conversation_id_index`(`conversation_id`);
alter table `conversation_notes` add index `conversation_notes_user_id_index`(`user_id`);
alter table `conversations` add index `conversations_last_message_at_index`(`last_message_at`);

-- Enregistrer les migrations comme faites (pour que « php artisan migrate » ne les rejoue pas).
set @lot := (select coalesce(max(batch), 0) + 1 from migrations);
insert into migrations (migration, batch) values ('2026_10_04_000030_create_conversation_notes', @lot);
