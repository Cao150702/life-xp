-- ============================================
-- LifeQuest Supabase Schema Migration
-- Version: 1.0.0
-- Date: 2026-04-28
-- ============================================

-- Enable required extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- ============================================
-- 1. PROFILES (extends auth.users)
-- ============================================
CREATE TABLE public.profiles (
    id          UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
    name        TEXT NOT NULL DEFAULT '',
    avatar      TEXT NOT NULL DEFAULT '🧑‍💻',
    total_xp    INTEGER NOT NULL DEFAULT 0 CHECK (total_xp >= 0),
    max_streak  INTEGER NOT NULL DEFAULT 0 CHECK (max_streak >= 0),
    created_at  TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at  TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- Auto-create profile on signup
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO public.profiles (id, name, avatar, total_xp, max_streak)
    VALUES (
        NEW.id,
        COALESCE(NEW.raw_user_meta_data->>'name', ''),
        COALESCE(NEW.raw_user_meta_data->>'avatar', '🧑‍💻'),
        0,
        0
    );
    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE TRIGGER on_auth_user_created
    AFTER INSERT ON auth.users
    FOR EACH ROW
    EXECUTE FUNCTION public.handle_new_user();

-- ============================================
-- 2. LOGS (activity records)
-- ============================================
CREATE TABLE public.logs (
    id          UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id     UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    category    TEXT NOT NULL,
    title       TEXT NOT NULL,
    duration    INTEGER NOT NULL CHECK (duration > 0),
    xp          INTEGER NOT NULL CHECK (xp >= 0),
    note        TEXT DEFAULT '',
    log_date    DATE NOT NULL DEFAULT CURRENT_DATE,
    log_time    TIME NOT NULL DEFAULT CURRENT_TIME,
    created_at  TIMESTAMPTZ NOT NULL DEFAULT now(),
    synced_at   TIMESTAMPTZ,
    is_deleted  BOOLEAN NOT NULL DEFAULT false
);

CREATE INDEX idx_logs_user_date ON public.logs(user_id, log_date DESC);
CREATE INDEX idx_logs_user_cat ON public.logs(user_id, category);
CREATE INDEX idx_logs_synced ON public.logs(user_id) WHERE synced_at IS NULL;

-- ============================================
-- 3. CUSTOM CATEGORIES
-- ============================================
CREATE TABLE public.custom_categories (
    id          UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id     UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    cat_id      TEXT NOT NULL,
    name        TEXT NOT NULL,
    icon        TEXT NOT NULL,
    color       TEXT NOT NULL,
    xp_per_min  INTEGER NOT NULL DEFAULT 2 CHECK (xp_per_min > 0),
    sort_order  INTEGER NOT NULL DEFAULT 0,
    created_at  TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE UNIQUE INDEX idx_custom_cat_user ON public.custom_categories(user_id, cat_id);

-- ============================================
-- 4. UNLOCKED ACHIEVEMENTS
-- ============================================
CREATE TABLE public.unlocked_achievements (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id         UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    achievement_id  TEXT NOT NULL,
    unlocked_at     TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE UNIQUE INDEX idx_ach_user ON public.unlocked_achievements(user_id, achievement_id);

-- ============================================
-- 5. TIMER SNAPSHOTS (in-progress timers)
-- ============================================
CREATE TABLE public.timer_snapshots (
    id          UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id     UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    category    TEXT NOT NULL,
    title       TEXT NOT NULL,
    started_at  TIMESTAMPTZ NOT NULL DEFAULT now(),
    created_at  TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_timer_user ON public.timer_snapshots(user_id);

-- ============================================
-- 6. ROW LEVEL SECURITY (RLS)
-- ============================================
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.logs ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.custom_categories ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.unlocked_achievements ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.timer_snapshots ENABLE ROW LEVEL SECURITY;

-- Profiles: users can read own profile, update own profile
CREATE POLICY "Users can view own profile"
    ON public.profiles FOR SELECT
    USING (auth.uid() = id);

CREATE POLICY "Users can update own profile"
    ON public.profiles FOR UPDATE
    USING (auth.uid() = id);

CREATE POLICY "Users can insert own profile"
    ON public.profiles FOR INSERT
    WITH CHECK (auth.uid() = id);

-- Logs: full CRUD for own data
CREATE POLICY "Users can view own logs"
    ON public.logs FOR SELECT
    USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own logs"
    ON public.logs FOR INSERT
    WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own logs"
    ON public.logs FOR UPDATE
    USING (auth.uid() = user_id);

CREATE POLICY "Users can delete own logs"
    ON public.logs FOR DELETE
    USING (auth.uid() = user_id);

-- Custom Categories: full CRUD for own data
CREATE POLICY "Users can view own custom categories"
    ON public.custom_categories FOR SELECT
    USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own custom categories"
    ON public.custom_categories FOR INSERT
    WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own custom categories"
    ON public.custom_categories FOR UPDATE
    USING (auth.uid() = user_id);

CREATE POLICY "Users can delete own custom categories"
    ON public.custom_categories FOR DELETE
    USING (auth.uid() = user_id);

-- Unlocked Achievements: full CRUD for own data
CREATE POLICY "Users can view own achievements"
    ON public.unlocked_achievements FOR SELECT
    USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own achievements"
    ON public.unlocked_achievements FOR INSERT
    WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can delete own achievements"
    ON public.unlocked_achievements FOR DELETE
    USING (auth.uid() = user_id);

-- Timer Snapshots: full CRUD for own data
CREATE POLICY "Users can view own timer snapshots"
    ON public.timer_snapshots FOR SELECT
    USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own timer snapshots"
    ON public.timer_snapshots FOR INSERT
    WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own timer snapshots"
    ON public.timer_snapshots FOR UPDATE
    USING (auth.uid() = user_id);

CREATE POLICY "Users can delete own timer snapshots"
    ON public.timer_snapshots FOR DELETE
    USING (auth.uid() = user_id);

-- ============================================
-- 7. UPDATED_AT AUTO-UPDATE TRIGGER
-- ============================================
CREATE OR REPLACE FUNCTION public.update_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = now();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER profiles_updated_at
    BEFORE UPDATE ON public.profiles
    FOR EACH ROW
    EXECUTE FUNCTION public.update_updated_at();

-- ============================================
-- 8. REALTIME SUBSCRIPTIONS
-- ============================================
ALTER PUBLICATION supabase_realtime ADD TABLE public.logs;
ALTER PUBLICATION supabase_realtime ADD TABLE public.profiles;
ALTER PUBLICATION supabase_realtime ADD TABLE public.unlocked_achievements;

-- ============================================
-- 9. HELPER FUNCTIONS
-- ============================================

-- Recalculate total_xp and max_streak from logs
CREATE OR REPLACE FUNCTION public.recalc_profile_stats(p_user_id UUID)
RETURNS void AS $$
DECLARE
    v_total_xp INTEGER;
    v_max_streak INTEGER;
BEGIN
    -- Total XP (excluding soft-deleted)
    SELECT COALESCE(SUM(xp), 0) INTO v_total_xp
    FROM public.logs
    WHERE user_id = p_user_id AND NOT is_deleted;

    -- Max streak: consecutive days with at least one log
    WITH distinct_days AS (
        SELECT DISTINCT log_date
        FROM public.logs
        WHERE user_id = p_user_id AND NOT is_deleted
        ORDER BY log_date DESC
    ),
    streak_calc AS (
        SELECT log_date,
               log_date - (ROW_NUMBER() OVER (ORDER BY log_date DESC))::INT AS grp
        FROM distinct_days
    ),
    streak_groups AS (
        SELECT grp, COUNT(*) AS streak_len
        FROM streak_calc
        GROUP BY grp
    )
    SELECT COALESCE(MAX(streak_len), 0) INTO v_max_streak FROM streak_groups;

    UPDATE public.profiles
    SET total_xp = v_total_xp,
        max_streak = v_max_streak
    WHERE id = p_user_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- ============================================
-- 10. BATCH IMPORT FUNCTION (for v3 JSON migration)
-- ============================================
CREATE OR REPLACE FUNCTION public.import_logs(
    p_user_id UUID,
    p_logs JSONB
)
RETURNS void AS $$
DECLARE
    log_rec JSONB;
    v_cat TEXT;
    v_cat_xpm INTEGER;
BEGIN
    FOR log_rec IN SELECT * FROM jsonb_array_elements(p_logs)
    LOOP
        v_cat := log_rec->>'cat';

        -- Check if it's a custom category
        SELECT xp_per_min INTO v_cat_xpm
        FROM public.custom_categories
        WHERE user_id = p_user_id AND cat_id = v_cat;

        -- Default XP per minute if not found (built-in cats)
        IF v_cat_xpm IS NULL THEN
            v_cat_xpm := CASE v_cat
                WHEN 'study' THEN 3
                WHEN 'research' THEN 4
                WHEN 'code' THEN 4
                WHEN 'sport' THEN 2
                WHEN 'read' THEN 2
                WHEN 'express' THEN 3
                ELSE 2
            END;
        END IF;

        INSERT INTO public.logs (id, user_id, category, title, duration, xp, note, log_date, log_time, synced_at)
        VALUES (
            COALESCE(log_rec->>'id', uuid_generate_v4())::UUID,
            p_user_id,
            v_cat,
            log_rec->>'title',
            (log_rec->>'dur')::INTEGER,
            COALESCE((log_rec->>'xp')::INTEGER, (log_rec->>'dur')::INTEGER * v_cat_xpm),
            COALESCE(log_rec->>'note', ''),
            (log_rec->>'date')::DATE,
            (log_rec->>'time')::TIME,
            now()
        )
        ON CONFLICT (id) DO NOTHING;
    END LOOP;

    -- Recalculate stats
    PERFORM public.recalc_profile_stats(p_user_id);
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
