-- Kouma : mise à jour de la base de données.
-- Avant d'importer : dans phpMyAdmin, cliquez sur le nom de votre base dans la colonne de gauche, puis sur l'onglet Importer.
-- Ce fichier ne s'importe qu'une fois : les tables n'existent pas encore.

-- 2026_10_05_000010_create_social_login
create table `social_accounts` (`id` bigint unsigned not null auto_increment primary key, `user_id` bigint unsigned not null, `provider` varchar(20) not null, `provider_user_id` varchar(191) not null, `email` varchar(255) null, `name` varchar(255) null, `avatar_url` varchar(500) null, `last_login_at` timestamp null, `created_at` timestamp null, `updated_at` timestamp null) default character set utf8mb4 collate 'utf8mb4_unicode_ci';
alter table `social_accounts` add constraint `social_accounts_user_id_foreign` foreign key (`user_id`) references `users` (`id`) on delete cascade;
alter table `social_accounts` add unique `social_accounts_provider_provider_user_id_unique`(`provider`, `provider_user_id`);
alter table `social_accounts` add index `social_accounts_user_id_provider_index`(`user_id`, `provider`);
alter table `users` add `has_password` tinyint(1) not null default '1';
alter table `users` add `needs_profile` tinyint(1) not null default '0';
alter table `users` add `signup_source` varchar(20) null;

-- 2026_10_05_000020_create_customer_followups
create table `customer_contacts` (`id` bigint unsigned not null auto_increment primary key, `user_id` bigint unsigned not null, `staff_id` bigint unsigned null, `channel` varchar(12) not null, `subject` varchar(190) null, `body` text null, `outcome` varchar(16) null, `template` varchar(30) null, `created_at` timestamp not null default CURRENT_TIMESTAMP) default character set utf8mb4 collate 'utf8mb4_unicode_ci';
alter table `customer_contacts` add index `customer_contacts_user_id_created_at_index`(`user_id`, `created_at`);
alter table `customer_contacts` add index `customer_contacts_user_id_index`(`user_id`);
alter table `customer_contacts` add index `customer_contacts_staff_id_index`(`staff_id`);
alter table `users` add `crm_status` varchar(16) null;
alter table `users` add `crm_next_follow_up_at` timestamp null;
alter table `users` add `crm_owner_id` bigint unsigned null;
alter table `users` add `crm_last_contacted_at` timestamp null;
alter table `users` add index `users_crm_status_index`(`crm_status`);
alter table `users` add index `users_crm_next_follow_up_at_index`(`crm_next_follow_up_at`);
alter table `users` add index `users_crm_owner_id_index`(`crm_owner_id`);

-- Enregistrer les migrations comme faites (pour que « php artisan migrate » ne les rejoue pas).
set @lot := (select coalesce(max(batch), 0) + 1 from migrations);
insert into migrations (migration, batch) values ('2026_10_05_000010_create_social_login', @lot);
insert into migrations (migration, batch) values ('2026_10_05_000020_create_customer_followups', @lot);
