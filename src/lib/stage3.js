import { supabase } from "./supabase.js";

export const PROGRAM_STATUSES=["Belum Dilaksanakan","Terjadwal","Sedang Berlangsung","Selesai","Ditunda"];
export const AGENDA_STATUSES=["Direncanakan","Berlangsung","Selesai","Ditunda","Dibatalkan"];
export const STUDENT_STATUSES=["Aktif","Pindah","Lulus","Tidak Aktif"];
export const PROBLEM_STATUSES=["Baru","Dalam Penanganan","Dipantau","Selesai","Referal"];
export const CATEGORIES=["Pribadi","Sosial","Belajar","Karier","Keluarga","Kedisiplinan"];
export const SUBCATEGORIES={
 Pribadi:["Emosi","Kepercayaan diri","Pengembangan diri","Pengendalian diri","Lainnya"],
 Sosial:["Pertemanan","Pergaulan","Konflik","Bullying","Komunikasi","Lainnya"],
 Belajar:["Motivasi belajar","Kesulitan belajar","Konsentrasi","Manajemen waktu","Prestasi","Kehadiran","Lainnya"],
 Karier:["Minat","Bakat","Cita-cita","Pilihan sekolah lanjutan","Perencanaan masa depan"],
 Keluarga:["Hubungan keluarga","Komunikasi keluarga","Kondisi lingkungan keluarga","Lainnya"],
 Kedisiplinan:["Tata tertib","Kehadiran","Keterlambatan","Perilaku","Lainnya"]
};
export const TABLES={annual:"annual_programs",semester:"semester_programs",agenda:"counselor_agendas",weekly:"weekly_schedules",daily:"daily_schedules",students:"students",problems:"student_needs_problems"};

export async function listRows(table,{search="",filters={},limit=1000}={}){
 let q=supabase.from(table).select("*").order("created_at",{ascending:false}).limit(limit);
 for(const [key,val] of Object.entries(filters)){if(val!==undefined&&val!==null&&val!=="")q=q.eq(key,val)}
 if(search)q=q.or(`program_name.ilike.%${search}%,full_name.ilike.%${search}%,activity.ilike.%${search}%,nis.ilike.%${search}%,nisn.ilike.%${search}%`);
 const {data,error}=await q;if(error)throw error;return data||[];
}
export async function getById(table,id){const {data,error}=await supabase.from(table).select("*").eq("id",id).single();if(error)throw error;return data}
export async function saveRow(table,payload,id){const r=id?await supabase.from(table).update(payload).eq("id",id).select().single():await supabase.from(table).insert(payload).select().single();if(r.error)throw r.error;return r.data}
export async function deleteRow(table,id){const {error}=await supabase.from(table).delete().eq("id",id);if(error)throw error}
export async function count(table){const {count,error}=await supabase.from(table).select("id",{count:"exact",head:true});if(error)throw error;return count||0}
export async function logStage3(userId,action,module,description,recordId=null){const {error}=await supabase.from("activity_logs").insert({user_id:userId,action,module,description,record_id:recordId});if(error)console.warn(error.message)}
export async function getCounselorId(userId){const {data,error}=await supabase.from("counselor_profile").select("id").eq("user_id",userId).single();if(error)throw error;return data.id}
export async function uploadRelatedDocument({userId,title,file,category,relatedModule,relatedRecordId,description=""}){
 if(!file||file.size>20*1024*1024)throw new Error("File wajib diisi dan maksimal 20 MB.");
 const allowed=["application/pdf","application/msword","application/vnd.openxmlformats-officedocument.wordprocessingml.document","application/vnd.ms-excel","application/vnd.openxmlformats-officedocument.spreadsheetml.sheet","application/vnd.ms-powerpoint","application/vnd.openxmlformats-officedocument.presentationml.presentation","image/jpeg","image/png","video/mp4","audio/mpeg"];
 if(file.type && !allowed.includes(file.type))throw new Error("Format file tidak diperbolehkan.");
 const path=userId+"/"+crypto.randomUUID()+"-"+file.name;
 const {error}=await supabase.storage.from("bk-documents").upload(path,file,{upsert:false});if(error)throw error;
 const {data,error:dbError}=await supabase.from("documents").insert({title,description,file_name:file.name,file_url:path,file_type:file.type||"application/octet-stream",file_size:file.size,category,uploaded_by:userId,related_module:relatedModule,related_record_id:relatedRecordId}).select().single();
 if(dbError){await supabase.storage.from("bk-documents").remove([path]);throw dbError}return data;
}
export async function downloadDocument(userId,doc){const {data,error}=await supabase.storage.from("bk-documents").createSignedUrl(doc.file_url,300);if(error)throw error;await logStage3(userId,"Download dokumen","Dokumen","Dokumen diunduh: "+doc.file_name,doc.id);window.open(data.signedUrl,"_blank")}
