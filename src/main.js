const modules = [
  {group:"Utama",items:[["dashboard","Dashboard","⌂"]]},
  {group:"Program",items:[["program-tahunan","Program Tahunan","▣"],["program-semester","Program Semester","▤"],["agenda","Agenda Kerja Konselor","◷"],["jadwal","Jadwal Konselor","▦"]]},
  {group:"Kegiatan Pelayanan",items:[["konseli","Daftar Konseli","♙"],["permasalahan","Kebutuhan & Permasalahan","!"]]},
  {group:"Aktivitas Pelayanan BK",items:[["asesmen","Pemahaman / Asesmen","◎"],["layanan","Pelayanan Langsung","◉"],["tindak-lanjut","Pelayanan Tindak Lanjut","↗"]]},
  {group:"Pengembangan Diri",items:[["pengembangan","MGBK & Pengembangan Kompetensi","★"]]},
  {group:"Pelaporan",items:[["pelaporan","Pelaporan","▥"]]},
  {group:"Evaluasi",items:[["evaluasi","Evaluasi","◒"]]},
  {group:"Dokumen & Pengaturan",items:[["dokumen","Dokumen / File Manager","▤"],["pengaturan","Pengaturan","⚙"]]}
];

const state = {
  page: localStorage.getItem("bk-page") || "dashboard",
  dark: localStorage.getItem("bk-dark") === "1",
  search: ""
};

const icon = (symbol) => '<span class="nav-icon">'+symbol+'</span>';

function sidebar(){
  return `
    <aside class="sidebar">
      <div class="brand">
        <div class="brand-mark">BK</div>
        <div><strong>SIM BK</strong><small>SMP Negeri 11 Palu</small></div>
      </div>
      <div class="profile-mini">
        <div class="avatar">NU</div>
        <div><strong>Nurhidayat Usman</strong><small>Guru Bimbingan & Konseling</small></div>
      </div>
      <nav>
        ${modules.map(g=>`<div class="nav-group"><div class="nav-label">${g.group}</div>${g.items.map(([id,label,s])=>`<button class="nav-item ${state.page===id?"active":""}" data-page="${id}">${icon(s)}<span>${label}</span></button>`).join("")}</div>`).join("")}
      </nav>
      <div class="privacy">🔒 <span>Data konseli dan catatan konseling bersifat rahasia.</span></div>
    </aside>`;
}

function header(){
  return `
    <header class="topbar">
      <button id="menu" class="icon-btn">☰</button>
      <div class="crumb">Sistem Informasi BK <span>/</span> <b>${pageTitle()}</b></div>
      <div class="top-actions">
        <label class="search"><span>⌕</span><input id="global-search" placeholder="Cari siswa, kegiatan, dokumen..." value="${state.search}"></label>
        <button id="theme" class="icon-btn" title="Mode gelap">${state.dark?"☀":"◐"}</button>
        <button class="user-chip"><span class="avatar sm">NU</span><span>Nurhidayat Usman</span></button>
      </div>
    </header>`;
}

function pageTitle(){
  const all=modules.flatMap(g=>g.items);
  return (all.find(x=>x[0]===state.page)||["","Dashboard"])[1];
}

function stat(label,value,change,cls){
  return `<div class="stat-card"><div class="stat-top"><span>${label}</span><b class="stat-icon ${cls}">●</b></div><strong class="stat-value">${value}</strong><small>${change}</small></div>`;
}

function dashboard(){
  const students=Number(localStorage.getItem("bk-students")||0);
  const cases=Number(localStorage.getItem("bk-cases")||0);
  const services=Number(localStorage.getItem("bk-services")||0);
  return `
  <section class="page">
    <div class="welcome"><div><p class="eyebrow">DASHBOARD BK</p><h1>Selamat datang, Bapak Hidayat 👋</h1><p>Kelola program dan layanan Bimbingan dan Konseling secara terstruktur dan terdokumentasi.</p></div><button class="primary" data-page="konseli">＋ Tambah Konseli</button></div>
    <div class="profile-banner">
      <div class="avatar xl">NU</div><div class="profile-text"><span>Guru Bimbingan dan Konseling</span><h2>Nurhidayat Usman, S.Pd</h2><p>SMP Negeri 11 Palu · Tahun Pelajaran 2026/2027</p></div>
      <button class="secondary" data-page="pengaturan">Edit Profil</button>
    </div>
    <div class="stats-grid">
      ${stat("Jumlah Konseli",students,"Data siswa asuh","blue")}${stat("Jumlah Kasus",cases,"Kebutuhan & permasalahan","orange")}${stat("Jumlah Layanan",services,"Layanan BK tercatat","green")}${stat("Asesmen","0","Sosiometri & AKPD","purple")}${stat("Kegiatan","0","Agenda terlaksana","teal")}${stat("Laporan","0","Bulanan / semester / tahunan","red")}${stat("Dokumen","0","Arsip digital","gray")}
    </div>
    <div class="grid-2">
      <div class="panel"><div class="panel-head"><div><h3>Ringkasan Pelayanan</h3><small>Aktivitas BK tahun pelajaran berjalan</small></div><button class="link-btn" data-page="pelaporan">Lihat laporan →</button></div><div class="empty-chart"><div class="bars"><i style="height:45%"></i><i style="height:70%"></i><i style="height:55%"></i><i style="height:85%"></i><i style="height:62%"></i><i style="height:92%"></i><i style="height:74%"></i></div><div class="chart-labels"><span>Jan</span><span>Feb</span><span>Mar</span><span>Apr</span><span>Mei</span><span>Jun</span><span>Jul</span></div></div></div>
      <div class="panel"><div class="panel-head"><div><h3>Akses Cepat</h3><small>Menu yang sering digunakan</small></div></div><div class="quick-grid"><button data-page="konseli">👥<b>Daftar Konseli</b><small>Kelola siswa asuh</small></button><button data-page="asesmen">◎<b>Asesmen</b><small>Sosiometri & AKPD</small></button><button data-page="layanan">◉<b>Pelayanan</b><small>Catat layanan BK</small></button><button data-page="jadwal">▦<b>Jadwal</b><small>Agenda konselor</small></button></div></div>
    </div>
    <div class="panel"><div class="panel-head"><div><h3>Gambaran Umum Sekolah</h3><small>Informasi yang dapat dilengkapi melalui Pengaturan</small></div><button class="secondary" data-page="pengaturan">Kelola Profil</button></div><div class="school-grid"><div><span>Nama Sekolah</span><b>SMP Negeri 11 Palu</b></div><div><span>NPSN</span><b>Belum diisi</b></div><div><span>Kepala Sekolah</span><b>Belum diisi</b></div><div><span>Jumlah Siswa</span><b>Belum diisi</b></div><div><span>Jumlah Rombel</span><b>Belum diisi</b></div><div><span>Alamat</span><b>Belum diisi</b></div></div></div>
  </section>`;
}

function generic(){
  const descriptions={
    "program-tahunan":"Kelola program tahunan BK, tujuan, bidang layanan, sasaran, materi, waktu, indikator, dan dokumen.",
    "program-semester":"Kelola program semester ganjil dan genap beserta alokasi waktu, metode, media, dan dokumen.",
    agenda:"Catat agenda kerja konselor, hasil kegiatan, tindak lanjut, dan bukti kegiatan.",
    jadwal:"Atur jadwal mingguan dan harian konselor dalam bentuk terstruktur.",
    konseli:"Kelola database siswa asuh dan riwayat layanan BK secara terpusat.",
    permasalahan:"Catat kebutuhan dan permasalahan konseli berdasarkan kategori serta tindak lanjut.",
    asesmen:"Kelola Sosiometri, AKPD, kunjungan rumah, catatan anekdot, dan konferensi kasus.",
    layanan:"Kelola konseling individual, konseling kelompok, konsultasi, bimbingan, dan referal.",
    "tindak-lanjut":"Kelola papan bimbingan, kotak masalah, biblio konseling, audio visual, dan media cetak.",
    pengembangan:"Dokumentasikan MGBK, pelatihan, IHT, ToT, seminar, webinar, workshop, dan diklat.",
    pelaporan:"Buat dan arsipkan laporan bulanan, semester, dan tahunan berdasarkan data sistem.",
    evaluasi:"Evaluasi program, proses/produk BK, kepuasan konseli, keberhasilan layanan, dan tindak lanjut.",
    dokumen:"Kelola seluruh dokumen dan berkas BK secara terpusat.",
    pengaturan:"Kelola profil sekolah, profil Guru BK, pengguna, keamanan, dan backup data."
  };
  return `<section class="page"><div class="page-heading"><div><p class="eyebrow">MODUL BK</p><h1>${pageTitle()}</h1><p>${descriptions[state.page]||"Kelola data dan administrasi Bimbingan dan Konseling."}</p></div><button class="primary" id="add-record">＋ Tambah Data</button></div><div class="panel"><div class="toolbar"><input class="field" placeholder="Cari data..."><select class="field"><option>Semua status</option><option>Aktif</option><option>Selesai</option><option>Arsip</option></select><button class="secondary">Filter</button><button class="secondary">Export</button></div><div class="table-empty"><div>▤</div><h3>Belum ada data</h3><p>Tambahkan data pertama untuk modul ini.</p><button class="primary" id="empty-add">＋ Tambah Data</button></div></div></section>`;
}

function app(){
  document.body.className=state.dark?"dark":"";
  document.querySelector("#app").innerHTML=`<div class="shell">${sidebar()}<main class="main">${header()}<div class="content">${state.page==="dashboard"?dashboard():generic()}</div></main></div>`;
  bind();
}

function bind(){
  document.querySelectorAll("[data-page]").forEach(b=>b.onclick=()=>{state.page=b.dataset.page;localStorage.setItem("bk-page",state.page);app()});
  document.querySelector("#theme")?.addEventListener("click",()=>{state.dark=!state.dark;localStorage.setItem("bk-dark",state.dark?"1":"0");app()});
  document.querySelector("#global-search")?.addEventListener("input",e=>state.search=e.target.value);
  document.querySelector("#menu")?.addEventListener("click",()=>document.body.classList.toggle("sidebar-open"));
  document.querySelectorAll("#add-record,#empty-add").forEach(b=>b.onclick=()=>alert("Form CRUD modul akan tersedia pada tahap pengembangan modul."));
}
app();
