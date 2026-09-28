import { supabase } from "./supabase.js";

export function requireSupabase() {
  if (!supabase) throw new Error("Database belum terhubung. Isi VITE_SUPABASE_URL dan VITE_SUPABASE_ANON_KEY.");
  return supabase;
}

export async function getProfile(userId) {
  const db = requireSupabase();
  const { data, error } = await db.from("users").select("*").eq("id", userId).single();
  if (error) throw error;
  return data;
}

export async function getSchoolProfile() {
  const db = requireSupabase();
  const { data, error } = await db.from("school_profile").select("*").limit(1).single();
  if (error) throw error;
  return data;
}

export async function getCounselorProfile(userId) {
  const db = requireSupabase();
  const { data, error } = await db.from("counselor_profile").select("*").eq("user_id", userId).single();
  if (error) throw error;
  return data;
}

export async function logActivity(userId, action, module, description, recordId = null) {
  const db = requireSupabase();
  const { error } = await db.from("activity_logs").insert({ user_id:userId, action, module, description, record_id:recordId });
  if (error) console.warn("Audit log:", error.message);
}
