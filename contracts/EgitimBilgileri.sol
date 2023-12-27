// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.0 <0.9.0;
//pragma experimental ABIEncoderV2;
import "./BaseContract.sol";
import "./BaseProperties.sol";

contract EgitimBilgileri is BaseProperties {
    BaseContract baseContract;
    uint public id;

    struct EgitimBilgi {
        uint id;
        address talepEdilenKurum;
        EgitimDurumu egitimDurumu;
        uint basTarih;
        uint bitTarih;
        //uint8 diplomaNotu;
        string diplomaBelge;
        string transcriptBelge;
        address universite;
        uint16 fakulte;
        uint16 bolum;
        OgretimTipi ogretimTipi;
        //    uint32 ogretimDili;
        Onay onayBilgi;
        //uint8 ulke;
        //uint32 sehir;
    }


    mapping(address => mapping(uint => EgitimBilgi)) public egitimBilgiListesi;
    address[] public onayBekleyenKisiler;
    EgitimBilgi[] public egitimBilgileri;
    mapping(address => uint[]) public kisiEgitimIdListesi;

    event EgitimBilgiEklendiLog(uint id, address _universite, uint basTarih, uint bitTarih);
    event EgitimBilgiGuncellendiLog(uint id, address _universite, uint basTarih, uint bitTarih);
    event EgitimBilgiTalepEdildiLog(uint id, address _universite, uint basTarih, uint bitTarih);
    event EgitimTalebiOnaylandiLog(address _onayKurumAdres, uint _tarih);


    constructor(address baseAddress)  {
        baseContract = BaseContract(baseAddress);
        id = 1;
    }
    modifier _yetkiliPaydas{
        require(baseContract.isUniversite(msg.sender),
            "Sadece Universite bu islemi yapabilir."
        );
        _;
    }
    modifier _sadeceKisi{
        require(baseContract.isKisi(msg.sender),
            "Bu islemi sadece Kisi yapabilir."
        );
        _;
    }
    function ekleEgitimBilgi(address _kisiAddress, EgitimDurumu egitimDurumu, uint basTarih, uint bitTarih, string memory diplomaBelge, string memory transcriptBelge, address universite, uint16 fakulte,
        uint16 bolum, OgretimTipi ogretimTipi) public _yetkiliPaydas {
        require(baseContract.isKisi(_kisiAddress), "Kisi bulunamadi");
        uint yeniId = id++;
        egitimBilgiListesi[_kisiAddress][yeniId].egitimDurumu = egitimDurumu;
        egitimBilgiListesi[_kisiAddress][yeniId].basTarih = basTarih;
        egitimBilgiListesi[_kisiAddress][yeniId].bitTarih = bitTarih;
        egitimBilgiListesi[_kisiAddress][yeniId].diplomaBelge = diplomaBelge;
        egitimBilgiListesi[_kisiAddress][yeniId].transcriptBelge = transcriptBelge;
        egitimBilgiListesi[_kisiAddress][yeniId].universite = universite;
        egitimBilgiListesi[_kisiAddress][yeniId].fakulte = fakulte;
        egitimBilgiListesi[_kisiAddress][yeniId].bolum = bolum;
        egitimBilgiListesi[_kisiAddress][yeniId].ogretimTipi = ogretimTipi;
        egitimBilgiListesi[_kisiAddress][yeniId].onayBilgi.zaman = block.timestamp;
        egitimBilgiListesi[_kisiAddress][yeniId].onayBilgi.adres = msg.sender;
        egitimBilgiListesi[_kisiAddress][yeniId].onayBilgi.durum = OnayDurum.Onaylandi;
        kisiEgitimIdListesi[_kisiAddress].push(yeniId);
        emit EgitimBilgiEklendiLog(yeniId, universite, basTarih, bitTarih);
    }

    function guncelleEgitimBilgi(address _kisiAddress, uint _egitimBilgiId, EgitimDurumu egitimDurumu, uint basTarih, uint bitTarih, string memory diplomaBelge, string memory transcriptBelge,
        address universite, uint16 fakulte, uint16 bolum, OgretimTipi ogretimTipi) external _yetkiliPaydas returns (uint){
        require(baseContract.isKisi(_kisiAddress), "Student not exists");
        require(egitimBilgiListesi[_kisiAddress][_egitimBilgiId].id > 1, "Kisinin bu adres ve egitim id degeri ile kaydi yoktur.");
        egitimBilgiListesi[_kisiAddress][_egitimBilgiId].egitimDurumu = egitimDurumu;
        egitimBilgiListesi[_kisiAddress][_egitimBilgiId].basTarih = basTarih;
        egitimBilgiListesi[_kisiAddress][_egitimBilgiId].bitTarih = bitTarih;
        egitimBilgiListesi[_kisiAddress][_egitimBilgiId].diplomaBelge = diplomaBelge;
        egitimBilgiListesi[_kisiAddress][_egitimBilgiId].transcriptBelge = transcriptBelge;
        egitimBilgiListesi[_kisiAddress][_egitimBilgiId].universite = universite;
        egitimBilgiListesi[_kisiAddress][_egitimBilgiId].fakulte = fakulte;
        egitimBilgiListesi[_kisiAddress][_egitimBilgiId].bolum = bolum;
        egitimBilgiListesi[_kisiAddress][_egitimBilgiId].ogretimTipi = ogretimTipi;
        egitimBilgiListesi[_kisiAddress][_egitimBilgiId].onayBilgi.zaman = block.timestamp;
        egitimBilgiListesi[_kisiAddress][_egitimBilgiId].onayBilgi.adres = msg.sender;
        egitimBilgiListesi[_kisiAddress][_egitimBilgiId].onayBilgi.durum = OnayDurum.Onaylandi;

        emit EgitimBilgiGuncellendiLog(_egitimBilgiId, universite, basTarih, bitTarih);
        return _egitimBilgiId;

    }

    function talepEtEgitimBilgi(address _kisiAddress, address _talepEdilenKurum, EgitimDurumu egitimDurumu, uint basTarih, uint bitTarih, string memory diplomaBelge, string memory transcriptBelge, address universite, uint16 fakulte,
        uint16 bolum, OgretimTipi ogretimTipi) external {
        require(baseContract.isKisi(_kisiAddress), "Kisi Mevcut Degil");
        require(!onayBekliyorMu(_kisiAddress), "Kisinin daha onceden onay bekleyen bir talebi vardir.");
        uint yeniId = id++;

        egitimBilgiListesi[_kisiAddress][yeniId].id = yeniId;
        egitimBilgiListesi[_kisiAddress][yeniId].talepEdilenKurum = _talepEdilenKurum;
        egitimBilgiListesi[_kisiAddress][yeniId].egitimDurumu = egitimDurumu;
        egitimBilgiListesi[_kisiAddress][yeniId].basTarih = basTarih;
        egitimBilgiListesi[_kisiAddress][yeniId].bitTarih = bitTarih;
        egitimBilgiListesi[_kisiAddress][yeniId].diplomaBelge = diplomaBelge;
        egitimBilgiListesi[_kisiAddress][yeniId].transcriptBelge = transcriptBelge;
        egitimBilgiListesi[_kisiAddress][yeniId].universite = universite;
        egitimBilgiListesi[_kisiAddress][yeniId].fakulte = fakulte;
        egitimBilgiListesi[_kisiAddress][yeniId].bolum = bolum;
        egitimBilgiListesi[_kisiAddress][yeniId].ogretimTipi = ogretimTipi;
        egitimBilgiListesi[_kisiAddress][yeniId].onayBilgi.durum = OnayDurum.OnayBekliyor;

        onayBekleyenKisiler.push(_kisiAddress);
        kisiEgitimIdListesi[_kisiAddress].push(yeniId);

        emit EgitimBilgiEklendiLog(yeniId, universite, basTarih, bitTarih);
    }

    function talepOnaylaEgitimBilgi(address _kisiAddress, uint _egitimBilgiId) public _yetkiliPaydas returns (uint){
        require(baseContract.isKisi(_kisiAddress), "Kisi bulunamadi");
        require(onayBekleyenKisiVeIdMevcutMu(_kisiAddress, _egitimBilgiId), "Kisinin onay bekleyen bir talebi yoktur.");
        require(egitimBilgiListesi[_kisiAddress][_egitimBilgiId].talepEdilenKurum == msg.sender, "Sadece Talep edilen kurum onaylayabilir.");

        egitimBilgiListesi[_kisiAddress][_egitimBilgiId].onayBilgi.durum = OnayDurum.Onaylandi;
        egitimBilgiListesi[_kisiAddress][_egitimBilgiId].onayBilgi.adres = msg.sender;
        egitimBilgiListesi[_kisiAddress][_egitimBilgiId].onayBilgi.zaman = block.timestamp;
        silOnayBekleyenListe(_kisiAddress);
        emit EgitimTalebiOnaylandiLog(msg.sender, block.timestamp);
        return _egitimBilgiId;

    }

    function getirOnayBekleyenListe() public view returns (address[] memory){
        return onayBekleyenKisiler;
    }

    function getirKisininEgitimIdListe(address _kisiAddress) public view returns (uint[] memory){
        return kisiEgitimIdListesi[_kisiAddress];
    }

    function getirKisininEgitimBilgisi(address _kisiAddress, uint _id) public view returns (EgitimBilgi memory){
        return egitimBilgiListesi[_kisiAddress][_id];
    }

    function getirKisininEgitimListesi(address _kisiAddress) public returns (EgitimBilgi[] memory){
     uint[] memory idliste =  getirKisininEgitimIdListe(_kisiAddress);
    
        for (uint i = 0; i < idliste.length; i++) {
             egitimBilgileri.push(getirKisininEgitimBilgisi(_kisiAddress,idliste[i]));
            }
        return egitimBilgileri;
    }
    


    function silOnayBekleyenListe(address _kisiAddress) private {

        require(onayBekleyenKisiler.length > 0, "Onay Bekleyen Listesi Bostur");

        if (onayBekleyenKisiler[onayBekleyenKisiler.length - 1] == _kisiAddress) {
            onayBekleyenKisiler.pop();
            return;
        }

        bool kisiVarMi = false;
        uint index;

        for (uint i = 0; i < onayBekleyenKisiler.length - 1; i++) {
            if (onayBekleyenKisiler[i] == _kisiAddress) {
                onayBekleyenKisiler[i] = onayBekleyenKisiler[i + 1];
                kisiVarMi = true;
                index = i;
            }
        }

        if (kisiVarMi == false) revert("Kisi Onay Bekleyen Listesinde Yoktur.");

        for (uint i = index; i < onayBekleyenKisiler.length - 1; i++) {
            onayBekleyenKisiler[i] = onayBekleyenKisiler[i + 1];
        }

        delete onayBekleyenKisiler[onayBekleyenKisiler.length - 1];
        onayBekleyenKisiler.pop();
    }

    function onayBekliyorMu(address _kisiAddress) private view returns (bool){
        for (uint i = 0; i < onayBekleyenKisiler.length; i++) {
            if (onayBekleyenKisiler[i] == _kisiAddress) {
                return true;
            }
        }
        return false;
    }

    function onayBekleyenKisiVeIdMevcutMu(address _kisiAddress, uint _egitimId) private view returns (bool){
        for (uint i = 0; i < onayBekleyenKisiler.length; i++) {
            if (onayBekleyenKisiler[i] == _kisiAddress
            && egitimBilgiListesi[_kisiAddress][_egitimId].id > 0
                && egitimBilgiListesi[_kisiAddress][_egitimId].onayBilgi.durum == OnayDurum.OnayBekliyor) {
                return true;
            }
        }
        return false;
    }

}