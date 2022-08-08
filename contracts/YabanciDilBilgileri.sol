// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.0 <0.9.0;
import "./EgitimBilgileri.sol";
import "./Registration.sol";
import "./BaseContract.sol";

contract YabanciDilBilgileri is BaseContract{
  uint public id;
   
    struct YabanciDil {
         uint id;
         OnaylayanKurum onayKurumTipi;
         address onayKurum;
         uint basTarih;
         uint bitTarih;
         EgitimBilgileri.OgretimTipi ogretimTipi;
         uint32 ogretimDili;

        }
        mapping(address=>mapping(uint=>YabanciDil)) public yabanciDiller;



        event YabanciDilEklendiLog(OnaylayanKurum _onaylayanKurumTipi,address _onayKurum, uint _basTarih, uint _bitTarih,EgitimBilgileri.OgretimTipi _ogretimTipi,uint32 _ogretimDili);

         function addYabanciDil(address _studentAddress, YabanciDil memory _ydBilgi)  public sadece_Uni_Firma_Kamu{
             require(kisiler[_studentAddress].durum,"Student not exists");
             uint yeniId=id++;
             yabanciDiller[_studentAddress][yeniId].onayKurumTipi=_ydBilgi.onayKurumTipi;
             yabanciDiller[_studentAddress][yeniId].onayKurum=_ydBilgi.onayKurum;
             yabanciDiller[_studentAddress][yeniId].basTarih=_ydBilgi.basTarih;
             yabanciDiller[_studentAddress][yeniId].bitTarih=_ydBilgi.bitTarih;
             yabanciDiller[_studentAddress][yeniId].ogretimTipi=_ydBilgi.ogretimTipi;
             yabanciDiller[_studentAddress][yeniId].ogretimDili=_ydBilgi.ogretimDili;
           
             emit YabanciDilEklendiLog(_ydBilgi.onayKurumTipi, _ydBilgi.onayKurum,  _ydBilgi.basTarih,  _ydBilgi.bitTarih, _ydBilgi.ogretimTipi, _ydBilgi.ogretimDili);
    }
       function updateYabanciDil(address _studentAddress, YabanciDil memory _ydBilgi)  public sadece_Uni_Firma_Kamu returns(uint){
             require(kisiler[_studentAddress].durum,"Student not exists");
             
             yabanciDiller[_studentAddress][_ydBilgi.id].onayKurumTipi=_ydBilgi.onayKurumTipi;
             yabanciDiller[_studentAddress][_ydBilgi.id].onayKurum=_ydBilgi.onayKurum;
             yabanciDiller[_studentAddress][_ydBilgi.id].basTarih=_ydBilgi.basTarih;
             yabanciDiller[_studentAddress][_ydBilgi.id].bitTarih=_ydBilgi.bitTarih;
             yabanciDiller[_studentAddress][_ydBilgi.id].ogretimTipi=_ydBilgi.ogretimTipi;
             yabanciDiller[_studentAddress][_ydBilgi.id].ogretimDili=_ydBilgi.ogretimDili;
           
             emit YabanciDilEklendiLog(_ydBilgi.onayKurumTipi, _ydBilgi.onayKurum,  _ydBilgi.basTarih,  _ydBilgi.bitTarih, _ydBilgi.ogretimTipi, _ydBilgi.ogretimDili);
             return    _ydBilgi.id;

    }



}