// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.0 <0.9.0;
//pragma experimental ABIEncoderV2;
import "./BaseContract.sol";
contract CalismaBilgileri is BaseContract{
  uint public id;

    struct CalismaBilgi {
         uint id;
         address talepEdilenKurum;
         uint32 pozisyon;
         uint8 sektor;
         CalismaTipi calismaTipi;
         string isAciklama;
         uint basTarih;
         uint bitTarih;
         uint8 ulke;
         uint32 sehir;
         Onay onayBilgi; 
        }
       
      
        mapping(address=>mapping(uint=>CalismaBilgi)) public calismaBilgileri;
      
       
        event CalismaBilgiEklendiLog(address _kisiAdres, uint8 _ulke, uint _pozisyon, uint _sektor);
        event CalismaBilgiGuncellendiLog(address _kisiAdres, uint8 _ulke, uint _pozisyon, uint _sektor);
            event CalismaBilgiTalepEdildiLog(address _talepEdilenKurum, uint8 _ulke, uint _pozisyon, uint _sektor);

         function ekleCalismaBilgi(address _kisiAddress, uint32 pozisyon, uint8 sektor, CalismaTipi calismaTipi, string memory isAciklama, uint basTarih, uint bitTarih, uint8 ulke, uint32 sehir)  public sadece_Uni_Firma_Kamu{
             require(kisiler[_kisiAddress].durum,"Student not exists");
             uint yeniId=id++;
            
             calismaBilgileri[_kisiAddress][yeniId].pozisyon=pozisyon;
             calismaBilgileri[_kisiAddress][yeniId].sektor=sektor;
             calismaBilgileri[_kisiAddress][yeniId].calismaTipi=calismaTipi;
             calismaBilgileri[_kisiAddress][yeniId].isAciklama=isAciklama;
             calismaBilgileri[_kisiAddress][yeniId].basTarih=basTarih;
             calismaBilgileri[_kisiAddress][yeniId].bitTarih=bitTarih;
             calismaBilgileri[_kisiAddress][yeniId].ulke=ulke;
             calismaBilgileri[_kisiAddress][yeniId].sehir=sehir;
             calismaBilgileri[_kisiAddress][yeniId].onayBilgi.zaman=block.timestamp;
             calismaBilgileri[_kisiAddress][yeniId].onayBilgi.durum=OnayDurum.Onaylandi;
             calismaBilgileri[_kisiAddress][yeniId].onayBilgi.adres=msg.sender;
           
             emit CalismaBilgiEklendiLog( _kisiAddress, ulke,pozisyon, sektor);
    }
       function guncelleCalismaBilgi(address _kisiAddress, uint _calismaBilgiId, uint32 pozisyon, uint8 sektor, CalismaTipi calismaTipi, string memory isAciklama, uint basTarih, uint bitTarih, uint8 ulke, uint32 sehir)  public sadece_Uni_Firma_Kamu returns(uint){
             require(kisiler[_kisiAddress].durum,"Student not exists");
             
             calismaBilgileri[_kisiAddress][_calismaBilgiId].pozisyon=pozisyon;
             calismaBilgileri[_kisiAddress][_calismaBilgiId].sektor=sektor;
             calismaBilgileri[_kisiAddress][_calismaBilgiId].calismaTipi=calismaTipi;
             calismaBilgileri[_kisiAddress][_calismaBilgiId].isAciklama=isAciklama;
             calismaBilgileri[_kisiAddress][_calismaBilgiId].basTarih=basTarih;
             calismaBilgileri[_kisiAddress][_calismaBilgiId].bitTarih=bitTarih;
             calismaBilgileri[_kisiAddress][_calismaBilgiId].ulke=ulke;
             calismaBilgileri[_kisiAddress][_calismaBilgiId].sehir=sehir;
             calismaBilgileri[_kisiAddress][_calismaBilgiId].onayBilgi.zaman=block.timestamp;
             calismaBilgileri[_kisiAddress][_calismaBilgiId].onayBilgi.durum=OnayDurum.Onaylandi;
             calismaBilgileri[_kisiAddress][_calismaBilgiId].onayBilgi.adres=msg.sender;
           
             emit CalismaBilgiGuncellendiLog( _kisiAddress, ulke, pozisyon, sektor);
             return _calismaBilgiId;

    }
       function talepEtCalismaBilgi(address _talepEdilenKurum, uint32 pozisyon, uint8 sektor, CalismaTipi calismaTipi, string memory isAciklama, uint basTarih, uint bitTarih, uint8 ulke, uint32 sehir)  public sadeceKisi{
             require(kisiler[msg.sender].durum,"Student not exists");
             uint yeniId=id++;

             calismaBilgileri[msg.sender][yeniId].talepEdilenKurum=_talepEdilenKurum;
             calismaBilgileri[msg.sender][yeniId].pozisyon=pozisyon;
             calismaBilgileri[msg.sender][yeniId].sektor=sektor;
             calismaBilgileri[msg.sender][yeniId].calismaTipi=calismaTipi;
             calismaBilgileri[msg.sender][yeniId].isAciklama=isAciklama;
             calismaBilgileri[msg.sender][yeniId].basTarih=basTarih;
             calismaBilgileri[msg.sender][yeniId].bitTarih=bitTarih;
             calismaBilgileri[msg.sender][yeniId].ulke=ulke;
             calismaBilgileri[msg.sender][yeniId].sehir=sehir;
             calismaBilgileri[msg.sender][yeniId].onayBilgi.durum=OnayDurum.OnayBekliyor;

           
             emit CalismaBilgiTalepEdildiLog( _talepEdilenKurum, ulke,pozisyon, sektor);
    }
     
}