// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.0 <0.9.0;

import "./BaseContract.sol";
import "./BaseProperties.sol";

contract Registration is BaseProperties{
    BaseContract baseContract;

    event KisiEkleLog(address _kisiAdres);
    event KisiGuncelleLog(address _kisiAdres, bool _durum);
    event KisiSilLog(address _kisiAdres);

    event UniversiteKayitLog(address _universiteAdres, string _isim, uint8 _ulke);
    event UniversiteGuncelleLog(address _universiteAdres, string _isim, uint8 _ulke);
    event UniversiteSilLog(address _universiteAdres);
    event FirmaEkleLog(address _firmaAdres, string _isim, uint _vergiNo, uint8 _ulke);
    event FirmaGuncelleLog(address _firmaAdres, string _isim, uint _vergiNo, uint8 _ulke);
    event FirmaSilLog(address _firmaAdres);
    event KamuKurumuEkleLog(address _kamuKurumuAdres, string _isim, uint8 _ulke);
    event KamuKurumuGuncelleLog(address _kamuKurumuAdres, string _isim, uint8 _ulke);
    event KamuKurumuSilLog(address _kamuKurumuAdres);
    event STKEkleLog(address _stkAdres, string _isim, uint8 _ulke);
    event STKGuncelleLog(address _stkAdres, string _isim, uint8 _ulke);
    event STKSilLog(address _stkAdres);
    event KursEkleLog(address _kursAdres, string _isim, uint8 _ulke);
    event KursGuncelleLog(address _kursAdres, string _isim, uint8 _ulke);
    event KursSilLog(address _kursAdres);
    event SertifikaMerkeziEkleLog(address _smAdres, string _isim, uint8 _ulke);
    event SertifikaMerkeziGuncelleLog(address _smAdres, string _isim, uint8 _ulke);
    event SertifikaMerkeziSilLog(address _smAdres);

    constructor (address _baseContract, address _yok, address _tobb, address _cb){
        baseContract = BaseContract(_baseContract);
        baseContract.paydasTanimla(_yok, _tobb, _cb);
    }

     YabanciDil[] public yabanciDilArray;
     Ulke[] public ulkeArray;
     NitelikKodu[] public nitelikKoduArray;

    modifier sadeceYOK{
        require(baseContract.isYOK(msg.sender),
            "Sadece YOK bu islemi yapabilir."
        );
        _;
    }
    modifier sadeceTOBB{
        require(baseContract.isTOBB(msg.sender),
            "Sadece TOBB bu islemi yapabilir."
        );
        _;
    }

    modifier sadeceCB{
        require(baseContract.isCB(msg.sender),
            "Sadece CB bu islemi yapabilir."
        );
        _;
    }

    modifier sadeceKisi{
        require(baseContract.isKisi(msg.sender),
            "Bu islemi sadece Kisi yapabilir."
        );
        _;
    }
    modifier sadeceUniversite{
        require(baseContract.isUniversite(msg.sender),
            "Sadece Universite bu islemi yapabilir."
        );
        _;
    }

    modifier sadeceKurs{
        require(baseContract.isKurs(msg.sender),
            "Bu islemi sadece Kurs yapabilir."
        );
        _;
    }
    modifier sadeceSertifikaMerkezi{
        require(baseContract.isSertifikaMerkezi(msg.sender),
            "Bu islemi sadece Sertifika Merkezleri yapabilir."
        );
        _;
    }

    modifier sadece_Uni_Firma_Kamu{
        require(baseContract.isUniversite(msg.sender) || baseContract.isFirma(msg.sender) || baseContract.isKamuKurumu(msg.sender),
            "Bu islemi Universiteler Kamu veya Ozel Kurumlar yapabilir."
        );
        _;
    }
        modifier sadece_SM_Kamu_Firma_Kurs{
        require(baseContract.isSertifikaMerkezi(msg.sender) || baseContract.isFirma(msg.sender) || baseContract.isKamuKurumu(msg.sender)|| baseContract.isKurs(msg.sender),
            "Bu islemi SM, Kurs,  Kamu veya Ozel Kurumlar yapabilir."
        );
        _;
    }
    modifier onlyKontratSahibi {
        require(msg.sender == address(this),
            "Bu islemi sadece kontrat sahibi yapabilir"
        );
        _;
    }
    function ekleUniversite(address _universiteAdres, string memory _isim, uint8 _ulke) public sadeceYOK {
        baseContract.ekleUniversite(_universiteAdres, _isim, _ulke);
        emit UniversiteKayitLog(_universiteAdres, _isim, _ulke);
    }

    function guncelleUniversite(address _universiteAdres, string memory _isim, uint8 _ulke) public sadeceYOK {
        baseContract.guncelleUniversite(_universiteAdres, _isim, _ulke);
        emit UniversiteGuncelleLog(_universiteAdres, _isim, _ulke);
    }

    function silUniversite(address _universiteAdres) public sadeceYOK {
        baseContract.silUniversite(_universiteAdres);
        emit UniversiteSilLog(_universiteAdres);
    }


    function ekleKisi(address _kisiAdres) public {

        baseContract.ekleKisi(_kisiAdres);
        emit KisiEkleLog(_kisiAdres);
        (_kisiAdres);
    }

    function guncelleKisi(address _kisiAdres,bool _durum) public {

        baseContract.guncelleKisi(_kisiAdres,_durum);
        emit KisiGuncelleLog(_kisiAdres, _durum);
    }

    function silKisi(address _kisiAdres) public {

        baseContract.silKisi(_kisiAdres);
        emit KisiSilLog(_kisiAdres);
    }


    function ekleFirma(address _firmaAdres, string memory _isim, uint _vergiNo, uint8 _ulke)
    public sadeceTOBB {
        require(!baseContract.isFirma(_firmaAdres),
            "Firma Zaten Mevcut"
        );
        baseContract.ekleFirma(_firmaAdres, _isim, _vergiNo, _ulke);

        emit FirmaEkleLog(_firmaAdres, _isim, _vergiNo, _ulke);

    }

    function guncelleFirma(address _firmaAdres, string memory _isim, uint _vergiNo, uint8 _ulke)
    public sadeceTOBB {
        require(!baseContract.isFirma(_firmaAdres),
            "Firma Zaten Mevcut"
        );
        baseContract.guncelleFirma(_firmaAdres, _isim, _vergiNo, _ulke);

        emit FirmaGuncelleLog(_firmaAdres, _isim, _vergiNo, _ulke);

    }

    function silFirma(address _firmaAdres)
    public sadeceTOBB {
        require(!baseContract.isFirma(_firmaAdres),
            "Firma Zaten Mevcut"
        );
        baseContract.silFirma(_firmaAdres);

        emit FirmaSilLog(_firmaAdres);

    }

    function ekleKamuKurumu(address _kamuKurumuAdres, string memory _isim, uint8 _ulke)
    public sadeceCB {
        baseContract.ekleKamuKurumu(_kamuKurumuAdres, _isim, _ulke);

        emit KamuKurumuEkleLog(_kamuKurumuAdres, _isim, _ulke);

    }

    function guncelleKamuKurumu(address _kamuKurumuAdres, string memory _isim, uint8 _ulke)
    public sadeceCB {
        baseContract.guncelleKamuKurumu(_kamuKurumuAdres, _isim, _ulke);

        emit KamuKurumuGuncelleLog(_kamuKurumuAdres, _isim, _ulke);

    }

    function silKamuKurumu(address _kamuKurumuAdres)
    public sadeceCB {
        baseContract.silKamuKurumu(_kamuKurumuAdres);

        emit KamuKurumuSilLog(_kamuKurumuAdres);

    }

    function ekleKurs(address _kursAdres, string memory _isim, uint8 _ulke)
    public sadece_Uni_Firma_Kamu {

        baseContract.ekleKurs(_kursAdres, _isim, _ulke);

        emit KursEkleLog(_kursAdres, _isim, _ulke);

    }

    function guncelleKurs(address _kursAdres, string memory _isim, uint8 _ulke)
    public sadece_Uni_Firma_Kamu {

        baseContract.guncelleKurs(_kursAdres, _isim, _ulke);

        emit KursGuncelleLog(_kursAdres, _isim, _ulke);

    }

    function silKurs(address _kursAdres)
    public sadece_Uni_Firma_Kamu {

        baseContract.silKurs(_kursAdres);

        emit KursSilLog(_kursAdres);

    }

    function ekleSTK(address _stkAdres, string memory _isim, uint8 _ulke)
    public sadeceCB {


        baseContract.ekleSTK(_stkAdres, _isim, _ulke);

        emit STKEkleLog(_stkAdres, _isim, _ulke);

    }

    function guncelleSTK(address _stkAdres, string memory _isim, uint8 _ulke)
    public sadeceCB {


        baseContract.guncelleSTK(_stkAdres, _isim, _ulke);

        emit STKGuncelleLog(_stkAdres, _isim, _ulke);

    }

    function silSTK(address _stkAdres)
    public sadeceCB {


        baseContract.silSTK(_stkAdres);

        emit STKSilLog(_stkAdres);

    }

    function ekleSertifikaMerkezi(address _smAdres, string memory _isim, uint8 _ulke)
    public sadeceTOBB {
        baseContract.ekleSertifikaMerkezi(_smAdres, _isim, _ulke);

        emit SertifikaMerkeziEkleLog(_smAdres, _isim, _ulke);

    }

    function guncelleSertifikaMerkezi(address _smAdres, string memory _isim, uint8 _ulke)
    public sadeceTOBB {
        baseContract.guncelleSertifikaMerkezi(_smAdres, _isim, _ulke);

        emit SertifikaMerkeziGuncelleLog(_smAdres, _isim, _ulke);

    }

    function silSertifikaMerkezi(address _smAdres)
    public sadeceTOBB {
        baseContract.silSertifikaMerkezi(_smAdres);
        emit SertifikaMerkeziSilLog(_smAdres);
    }

     function getDilListesi() public  view returns(YabanciDil[] memory) {  
        return yabanciDilArray;
    }


    function ekleYabanciDil(uint32  _dilId, string memory _dilAdi)
    public sadeceCB {
        yabanciDilArray.push(YabanciDil(_dilId,_dilAdi));
    }

    function getUlkeListesi() public  view returns(Ulke[] memory) {  
        return ulkeArray;
    }
    
    function ekleUlke(uint8  _ulkeId, string memory _ulkeAdi)
    public sadeceCB {
       ulkeArray.push(Ulke(_ulkeId,_ulkeAdi));

    }
    

        function getNitelikKoduListesi() public  view returns(NitelikKodu[] memory) {  
        return nitelikKoduArray;
    }
    
    function ekleNitelikKodu(uint  _kod, string memory _nitelikAdi)
    public sadece_SM_Kamu_Firma_Kurs {
       nitelikKoduArray.push(NitelikKodu(_kod,_nitelikAdi));

    }
}

