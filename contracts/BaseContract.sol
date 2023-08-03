// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.0 <0.9.0;

contract BaseContract {
    address public YOK;
    address TOBB;
    address CB;

    function paydasTanimla(address _yok, address _tobb, address _cb) public {
        YOK = _yok;
        TOBB = _tobb;
        CB = _cb;
    }

    struct Kisi
    {
        bool durum;

    }
    enum EgitimDurumu {
        Lisans,
        OnLisans,
        YuksekLisans,
        Doktora}

    enum OgretimTipi {
        OrgunOgretim,
        AcikOgretim,
        IkinciOgretim,
        UzaktanOgretim}

    enum CalismaTipi {
        YariZamanli,
        TamZamanli,
        Stajyer
    }

    struct Onay {
        uint zaman;
        address adres;
        OnayDurum durum;
    }
    enum OnayDurum {
        OnayBekliyor,
        Onaylandi,
        Reddedildi
    }
    struct Universite
    {
        bool durum;
        string isim;
        uint8 ulke;
    }

    struct Akademisyen
    {
        bool durum;
        address universite;
        uint16 bolum;
        Unvan unvan;
        string ad;
        string soyad;
    }

    enum Unvan {DR, AS_PROF, PROF, MD}
    enum Seviye {Temel, Orta, Iyi, Ileri}
    enum Cinsiyet{Erkek, Kadin}
    enum AskerlikDurum{Yapildi, Tecilli, Muaf}
    enum EhliyetDurum{Yok, A, B, C, D, E}
    enum OnaylayanKurum {
        Universite,
        Firma,
        Kamu,
        STK,
        SertifikaMerkezi,
        Kurs
    }
    struct Firma
    {
        bool durum;
        uint8 ulke;
        uint vergiNo;
        string isim;
    }

    struct KamuKurumu
    {
        bool durum;
        string isim;
        uint8 ulke;
    }

    struct STK
    {
        bool durum;
        string isim;
        uint8 ulke;
    }

    struct SertifikaMerkezi
    {
        bool durum;
        string isim;
        uint8 ulke;
    }

    struct Kurs
    {
        bool durum;
        string isim;
        uint8 ulke;
    }

    struct YabanciDil
    {
        uint32 id;
        string isim;
    }
    struct Ulke
    {
        uint8 id;
        string isim;
    }
    modifier sadeceYOK{
        require(msg.sender == YOK,
            "Sadece YOK bu islemi yapabilir."
        );
        _;
    }

    modifier sadeceTOBB{
        require(msg.sender == TOBB,
            "Sadece TOBB bu islemi yapabilir."
        );
        _;
    }

    modifier sadeceCB{
        require(msg.sender == CB,
            "Sadece CB bu islemi yapabilir."
        );
        _;
    }

    modifier sadeceKisi{
        require(kisiler[msg.sender].durum,
            "Bu islemi sadece Kisi yapabilir."
        );
        _;
    }
    modifier sadeceUniversite{
        require(universiteler[msg.sender].durum,
            "Sadece Universite bu islemi yapabilir."
        );
        _;
    }

    modifier sadeceKurs{
        require(kurslar[msg.sender].durum,
            "Bu islemi sadece Kurs yapabilir."
        );
        _;
    }
    modifier sadeceSertifikaMerkezi{
        require(sertifikaMerkezleri[msg.sender].durum,
            "Bu islemi sadece Sertifika Merkezleri yapabilir."
        );
        _;
    }

    modifier sadece_Uni_Firma_Kamu{
        require(universiteler[msg.sender].durum || firmalar[msg.sender].durum || kamuKurumlari[msg.sender].durum,
            "Bu islemi Universiteler Kamu veya Ozel Kurumlar yapabilir."
        );
        _;
    }
    modifier onlyKontratSahibi {
        require(msg.sender == address(this),
            "Bu islemi sadece kontrat sahibi yapabilir"
        );
        _;
    }

    function isYOK(address _address) public view returns (bool){
        return YOK == _address;
    }

    function isTOBB(address _address) public view returns (bool){
        return TOBB == _address;
    }

    function isCB(address _address) public view returns (bool){
        return CB == _address;
    }

    function isUniversite(address _address) public view returns (bool){
        return universiteler[_address].durum;
    }

    function isKisi(address _address) public view returns (bool){
        return kisiler[_address].durum;
    }

    function isKamuKurumu(address _address) public view returns (bool){
        return kamuKurumlari[_address].durum;
    }

    function isFirma(address _address) public view returns (bool){
        return firmalar[_address].durum;
    }

    function isKurs(address _address) public view returns (bool){
        return kurslar[_address].durum;
    }

    function isSTK(address _address) public view returns (bool){
        return stklar[_address].durum;
    }

    function isSertifikaMerkezi(address _address) public view returns (bool){
        return sertifikaMerkezleri[_address].durum;
    }

    mapping(address => Kisi) public kisiler;
    mapping(address => Universite) public universiteler;
    mapping(address => Akademisyen) public akademisyenler;
    mapping(address => Firma) public  firmalar;
    mapping(address => Kurs) public  kurslar;
    mapping(address => KamuKurumu) public kamuKurumlari;
    mapping(address => STK) public stklar;
    mapping(address => SertifikaMerkezi) public sertifikaMerkezleri;
    
    mapping(uint32 => YabanciDil) public diller;

 

    address[] public kisiAdresleri  ;
    address[] public universiteAdresleri;
    address[] public firmaAdresleri;
    address[] public kursAdresleri;
    address[] public kamuKurumAdresleri;
    address[] public stkAdresleri;
    address[] public smAdresleri;

    function ekleUniversite(address _universiteAdres, string memory _isim, uint8 _ulke) public {
        require(!isUniversite(_universiteAdres),
            "Universite Zaten Mevcut"
        );

        universiteler[_universiteAdres].durum = true;
        universiteler[_universiteAdres].isim = _isim;
        universiteler[_universiteAdres].ulke = _ulke;
        universiteAdresleri.push(_universiteAdres);

    }

    function guncelleUniversite(address _universiteAdres, string memory _isim, uint8 _ulke) public {
        require(isUniversite(_universiteAdres),
            "Universite Mevcut Degil"
        );

        universiteler[_universiteAdres].durum = true;
        universiteler[_universiteAdres].isim = _isim;
        universiteler[_universiteAdres].ulke = _ulke;


    }

    function silUniversite(address _universiteAdres) public {
        require(isUniversite(_universiteAdres),
            "Universite Zaten Mevcut"
        );

        delete universiteler[_universiteAdres];


    }

     function getUniversiteListesi() public sadeceYOK view returns(Universite[] memory){
      
        Universite [] memory result = new Universite[](universiteAdresleri.length);
        uint index=0;
        for(uint i = 0; i< universiteAdresleri.length; i++){
           result[index++]=universiteler[universiteAdresleri[i]];
        }
        return result;
    }

    function getKamuKurumuListesi() public sadeceCB view  returns(KamuKurumu[] memory)  {
      
        KamuKurumu [] memory result = new KamuKurumu[](kamuKurumAdresleri.length);
        uint index=0;
        for(uint i = 0; i< kamuKurumAdresleri.length; i++){
           result[index++]=kamuKurumlari[kamuKurumAdresleri[i]];
        }
        return result;
    }

     function getFirmaListesi() public sadeceTOBB view returns(Firma[] memory){
      
        Firma [] memory result = new Firma[](firmaAdresleri.length);
        uint index=0;
        for(uint i = 0; i< firmaAdresleri.length; i++){
           result[index++]=firmalar[firmaAdresleri[i]];
        }
        return result;
    }
     function getStkListesi() public sadeceCB view returns(STK[] memory){
      
        STK [] memory result = new STK[](stkAdresleri.length);
        uint index=0;
        for(uint i = 0; i< stkAdresleri.length; i++){
           result[index++]=stklar[stkAdresleri[i]];
        }
        return result;
    }
     function getSmListesi() public sadeceTOBB view returns(SertifikaMerkezi[] memory){
      
        SertifikaMerkezi [] memory result = new SertifikaMerkezi[](smAdresleri.length);
        uint index=0;
        for(uint i = 0; i< smAdresleri.length; i++){
           result[index++]=sertifikaMerkezleri[smAdresleri[i]];
        }
        return result;
    }

      function getKursListesi() public view returns(Kurs[] memory){
      
        Kurs [] memory result = new Kurs[](kursAdresleri.length);
        uint index=0;
        for(uint i = 0; i< kursAdresleri.length; i++){
           result[index++]=kurslar[kursAdresleri[i]];
        }
        return result;
    }

    function ekleKisi(address _kisiAdres) public {
        require(!isKisi(_kisiAdres),
            "Kisi Zaten Mevcut"
        );

        kisiler[_kisiAdres].durum = true;
        kisiAdresleri.push(_kisiAdres);

    }

    function guncelleKisi(address _kisiAdres, bool _durum) public {
        require(isKisi(_kisiAdres),
            "Kisi Mevcut Degil"
        );

        kisiler[_kisiAdres].durum = _durum;


    }

    function silKisi(address _kisiAdres) public {
        require(isKisi(_kisiAdres),
            "Kisi Mevcut Degil"
        );

        delete kisiler[_kisiAdres];


    }


    function ekleFirma(address _firmaAdres, string memory _isim, uint _vergiNo, uint8 _ulke)
    public {
        require(!isFirma(_firmaAdres),
            "Firma Zaten Mevcut"
        );

        firmalar[_firmaAdres].durum = true;
        firmalar[_firmaAdres].isim = _isim;
        firmalar[_firmaAdres].ulke = _ulke;
        firmalar[_firmaAdres].vergiNo = _vergiNo;
        firmaAdresleri.push(_firmaAdres);

    }

    function guncelleFirma(address _firmaAdres, string memory _isim, uint _vergiNo, uint8 _ulke)
    public {
        require(isFirma(_firmaAdres),
            "Firma Mevcut Degil"
        );

        firmalar[_firmaAdres].durum = true;
        firmalar[_firmaAdres].isim = _isim;
        firmalar[_firmaAdres].ulke = _ulke;
        firmalar[_firmaAdres].vergiNo = _vergiNo;


    }

    function silFirma(address _firmaAdres)
    public {
        require(isFirma(_firmaAdres),
            "Firma Mevcut Degil"
        );

        delete firmalar[_firmaAdres];


    }

    function ekleKamuKurumu(address _kamuKurumuAdres, string memory _isim, uint8 _ulke)
    public {
        require(!isKamuKurumu(_kamuKurumuAdres),
            "Kamu Kurumu Zaten Mevcut"
        );

        kamuKurumlari[_kamuKurumuAdres].durum = true;
        kamuKurumlari[_kamuKurumuAdres].isim = _isim;
        kamuKurumlari[_kamuKurumuAdres].ulke = _ulke;
        kamuKurumAdresleri.push(_kamuKurumuAdres);

    }

    function guncelleKamuKurumu(address _kamuKurumuAdres, string memory _isim, uint8 _ulke)
    public {
        require(isKamuKurumu(_kamuKurumuAdres),
            "Kamu Kurumu Mevcut Degil"
        );

        kamuKurumlari[_kamuKurumuAdres].durum = true;
        kamuKurumlari[_kamuKurumuAdres].isim = _isim;
        kamuKurumlari[_kamuKurumuAdres].ulke = _ulke;
    }

    function silKamuKurumu(address _kamuKurumuAdres)
    public {
        require(isKamuKurumu(_kamuKurumuAdres),
            "Kamu Kurumu Mevcut Degil"
        );

        delete kamuKurumlari[_kamuKurumuAdres];
    }

    function ekleKurs(address _kursAdres, string memory _isim, uint8 _ulke)
    public {
        require(!isKurs(_kursAdres),
            "Kurs Merkezi Zaten Mevcut"
        );

        kurslar[_kursAdres].durum = true;
        kurslar[_kursAdres].isim = _isim;
        kurslar[_kursAdres].ulke = _ulke;
        kursAdresleri.push(_kursAdres);

    }

    function guncelleKurs(address _kursAdres, string memory _isim, uint8 _ulke)
    public {
        require(isKurs(_kursAdres),
            "Kurs Merkezi Mevcut Degil"
        );

        kurslar[_kursAdres].durum = true;
        kurslar[_kursAdres].isim = _isim;
        kurslar[_kursAdres].ulke = _ulke;


    }

    function silKurs(address _kursAdres)
    public {
        require(isKurs(_kursAdres),
            "Kurs Merkezi Mevcut Degil"
        );

        delete kurslar[_kursAdres];


    }

    function ekleSTK(address _stkAdres, string memory _isim, uint8 _ulke)
    public {
        require(!isSTK(_stkAdres),
            "Sivil Toplum Kurulusu Zaten Mevcut"
        );

        stklar[_stkAdres].durum = true;
        stklar[_stkAdres].isim = _isim;
        stklar[_stkAdres].ulke = _ulke;
        stkAdresleri.push(_stkAdres);

    }

    function guncelleSTK(address _stkAdres, string memory _isim, uint8 _ulke)
    public {
        require(isSTK(_stkAdres),
            "Sivil Toplum Kurulusu Mevcut Degil"
        );

        stklar[_stkAdres].durum = true;
        stklar[_stkAdres].isim = _isim;
        stklar[_stkAdres].ulke = _ulke;

    }

    function silSTK(address _stkAdres)
    public {
        require(isSTK(_stkAdres),
            "Sivil Toplum Kurulusu Mevcut Degil"
        );
        delete stklar[_stkAdres];

    }

    function ekleSertifikaMerkezi(address _smAdres, string memory _isim, uint8 _ulke)
    public {
        require(!isSertifikaMerkezi(_smAdres),
            "Sertifika Merkezi Zaten Mevcut"
        );


        sertifikaMerkezleri[_smAdres].durum = true;
        sertifikaMerkezleri[_smAdres].isim = _isim;
        sertifikaMerkezleri[_smAdres].ulke = _ulke;
        smAdresleri.push(_smAdres);
    }

    function guncelleSertifikaMerkezi(address _smAdres, string memory _isim, uint8 _ulke)
    public {
        require(isSertifikaMerkezi(_smAdres),
            "Sertifika Merkezi Mevcut Degil"
        );

        sertifikaMerkezleri[_smAdres].durum = true;
        sertifikaMerkezleri[_smAdres].isim = _isim;
        sertifikaMerkezleri[_smAdres].ulke = _ulke;

    }

    function silSertifikaMerkezi(address _smAdres)
    public {
        require(isSertifikaMerkezi(_smAdres),
            "Sertifika Merkezi Mevcut Degil"
        );
        delete sertifikaMerkezleri[_smAdres];

    }

}