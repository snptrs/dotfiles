FasdUAS 1.101.10   ��   ��    k             l     ��  ��      Backup All Databases     � 	 	 *   B a c k u p   A l l   D a t a b a s e s   
  
 l     ��  ��    @ : Created by BLUEFROG/Jim Neumann on Weekday Month Day Year     �   t   C r e a t e d   b y   B L U E F R O G / J i m   N e u m a n n   o n   W e e k d a y   M o n t h   D a y   Y e a r      l     ��  ��    B < Copyright 2023 DEVONtechnologies, LLC. All rights reserved.     �   x   C o p y r i g h t   2 0 2 3   D E V O N t e c h n o l o g i e s ,   L L C .   A l l   r i g h t s   r e s e r v e d .      l     ��������  ��  ��        l      ��  ��    � � Verifies, optimizes, and compresses all open databases as a backup.
Errors logged but proceed gracefully. I included an optional alert sound as we do have blind users too.
     �  Z   V e r i f i e s ,   o p t i m i z e s ,   a n d   c o m p r e s s e s   a l l   o p e n   d a t a b a s e s   a s   a   b a c k u p . 
 E r r o r s   l o g g e d   b u t   p r o c e e d   g r a c e f u l l y .   I   i n c l u d e d   a n   o p t i o n a l   a l e r t   s o u n d   a s   w e   d o   h a v e   b l i n d   u s e r s   t o o . 
      l     ��������  ��  ��        x     �� ����    4    ��  
�� 
frmk   m     ! ! � " "  F o u n d a t i o n��     # $ # x    �� %����   % 2   ��
�� 
osax��   $  & ' & j    �� (�� 0 thesound theSound ( N     ) ) n    * + * o    ���� 0 nssound NSSound + m    ��
�� misccura '  , - , j    �� .�� 0 
allowsound 
allowSound . m    ��
�� boovfals -  / 0 / j     "�� 1�� 0 failuresound failureSound 1 m     ! 2 2 � 3 3  P i n g 0  4 5 4 j   # %�� 6�� 0 succeedsound succeedSound 6 m   # $ 7 7 � 8 8 
 G l a s s 5  9 : 9 j   & (�� ;�� 0 
backupdest 
backupDest ; m   & ' < < � = = j ~ / B a c k u p s   a n d   A p p   S y n c i n g / B a c k u p s / D E V O N t h i n k   b a c k u p s / :  > ? > p   ) ) @ @ ������ 0 	dobackups 	doBackups��   ?  A B A l     ��������  ��  ��   B  C D C i   ) , E F E I     ������
�� .aevtoappnull  �   � ****��  ��   F O    
 G H G I   	������
�� .aevtoappnull  �   � ****��  ��   H o     ���� 0 	dobackups 	doBackups D  I J I l     ��������  ��  ��   J  K L K i   - 0 M N M I      �������� "0 performreminder performReminder��  ��   N O    
 O P O I   	������
�� .aevtoappnull  �   � ****��  ��   P o     ���� 0 	dobackups 	doBackups L  Q R Q l     ��������  ��  ��   R  S T S h   1 <�� U�� 0 	dobackups 	doBackups U O    � V W V k   � X X  Y Z Y I   ������
�� .miscactvnull��� ��� null��  ��   Z  [ \ [ r     ] ^ ] n    _ ` _ 1    ��
�� 
txdl ` 1    ��
�� 
ascr ^ o      ���� 0 od   \  a b a l   ��������  ��  ��   b  c d c r     e f e 2   ��
�� 
DTkb f o      ���� 0 alldbs allDBs d  g h g r     i j i m    ����   j o      ���� 0 failurecount failureCount h  k l k l   ��������  ��  ��   l  m n m l   �� o p��   o E ? Using pure AS methods for date construction as an aid to users    p � q q ~   U s i n g   p u r e   A S   m e t h o d s   f o r   d a t e   c o n s t r u c t i o n   a s   a n   a i d   t o   u s e r s n  r s r r    ? t u t l      v���� v I     ������
�� .misccurdldt    ��� null��  ��  ��  ��   u K     ( w w �� x y
�� 
year x o   ! "���� 0 y   y �� z {
�� 
mnth z o   # $���� 0 m   { �� |��
�� 
day  | o   % &���� 0 d  ��   s  } ~ } r   @ e  �  J   @ R � �  � � � n  @ J � � � I   A J�� ����� 0 zeropad   �  ��� � c   A F � � � o   A B���� 0 m   � m   B E��
�� 
long��  ��   �  f   @ A �  ��� � n  J P � � � I   K P�� ����� 0 zeropad   �  ��� � o   K L���� 0 d  ��  ��   �  f   J K��   � J       � �  � � � o      ���� 0 m   �  ��� � o      ���� 0 d  ��   ~  � � � r   f m � � � m   f i � � � � �  - � n      � � � 1   j l��
�� 
txdl � 1   i j��
�� 
ascr �  � � � l  n y � � � � r   n y � � � c   n w � � � J   n s � �  � � � o   n o���� 0 y   �  � � � o   o p���� 0 m   �  ��� � o   p q���� 0 d  ��   � m   s v��
�� 
TEXT � o      ���� 0 currentdate currentDate �   Using ISO 8601 date    � � � � (   U s i n g   I S O   8 6 0 1   d a t e �  � � � l  z z��������  ��  ��   �  � � � X   z� ��� � � k   �� � �  � � � l   � ��� � ���   � � � If someone renames the database in the Finder, the displayed name will be different in Database Properties, so use the filename at the end of the database's path.     � � � �H   I f   s o m e o n e   r e n a m e s   t h e   d a t a b a s e   i n   t h e   F i n d e r ,   t h e   d i s p l a y e d   n a m e   w i l l   b e   d i f f e r e n t   i n   D a t a b a s e   P r o p e r t i e s ,   s o   u s e   t h e   f i l e n a m e   a t   t h e   e n d   o f   t h e   d a t a b a s e ' s   p a t h .   �  � � � r   � � � � � n   � � � � � 1   � ���
�� 
ppth � o   � ����� 0 thedatabase theDatabase � o      ���� 0 dbpath dbPath �  � � � r   � � � � � m   � � � � � � �  / � n      � � � 1   � ���
�� 
txdl � 1   � ���
�� 
ascr �  � � � r   � � � � � n   � � � � � 4  � ��� �
�� 
citm � m   � ������� � o   � ����� 0 dbpath dbPath � o      ���� 0 dbnamewithext dbNameWithExt �  � � � r   � � � � � m   � � � � � � �  . � n      � � � 1   � ���
�� 
txdl � 1   � ���
�� 
ascr �  � � � r   � � � � � c   � � � � � l  � � ����� � n   � � � � � 7  � ��� � �
�� 
citm � m   � �����  � m   � ������� � o   � ����� 0 dbnamewithext dbNameWithExt��  ��   � m   � ���
�� 
TEXT � o      ���� 0 dbname dbName �  � � � r   � � � � � o   � ����� 0 od   � n      � � � 1   � ���
�� 
txdl � 1   � ���
�� 
ascr �  � � � r   � � � � � l  � � ���~ � c   � � � � � b   � � � � � b   � � � � � b   � � � � � b   � � � � � b   � � � � � b   � � � � � o   � ��}�} 0 
backupdest 
backupDest � o   � ��|�| 0 currentdate currentDate � m   � � � � � � �  / � o   � ��{�{ 0 dbname dbName � m   � � � � � � �    � o   � ��z�z 0 currentdate currentDate � m   � � � � � � �  . d t B a s e 2 � m   � ��y
�y 
TEXT�  �~   � o      �x�x 0 savepath savePath �  � � � l  � ��w�v�u�w  �v  �u   �    l  � ��t�s�r�t  �s  �r    l  � ��q�q   5 / Backup processes ---------------------------		    � ^   B a c k u p   p r o c e s s e s   - - - - - - - - - - - - - - - - - - - - - - - - - - - 	 	  I  � ��p	

�p .DTpacd40bool       utxt	 b   � � l  � ��o�n I  � ��m�l
�m .sysolocSutxt        TEXT l  � ��k�j m   � � � * C r e a t i n g   b a c k u p   f o r :  �k  �j  �l  �o  �n   o   � ��i�i 0 dbname dbName
 �h�g
�h 
DTsp m   � ��f�f �g    I  � �e�d
�e .sysodelanull��� ��� nmbr m   � ��c�c �d    t  � k  �  I �b�a
�b .DTpacd41bool    ��� utxt l �`�_ I �^�]
�^ .sysolocSutxt        TEXT l  �\�[  m  !! �""  V e r i f y i n g &�\  �[  �]  �`  �_  �a   #$# I �Z%�Y
�Z .sysodelanull��� ��� nmbr% m  �X�X �Y  $ &�W& Z  �'(�V)' >  *+* l ,�U�T, I �S�R-
�S .DTpacd29long    ��� null�R  - �Q.�P
�Q 
DTkb. o  �O�O 0 thedatabase theDatabase�P  �U  �T  + m  �N�N  ( r  #3/0/ n #1121 I  $1�M3�L�M 0 reporterror reportError3 454 o  $%�K�K 0 dbname dbName5 676 I %,�J8�I
�J .sysolocSutxt        TEXT8 l %(9�H�G9 m  %(:: �;; ( D a t a b a s e   i s   d a m a g e d .�H  �G  �I  7 <�F< o  ,-�E�E 0 failurecount failureCount�F  �L  2  f  #$0 o      �D�D 0 failurecount failureCount�V  ) k  6�== >?> I 6A�C@�B
�C .DTpacd41bool    ��� utxt@ l 6=A�A�@A I 6=�?B�>
�? .sysolocSutxt        TEXTB l 69C�=�<C m  69DD �EE  O p t i m i z i n g &�=  �<  �>  �A  �@  �B  ? FGF I BG�;H�:
�; .sysodelanull��� ��� nmbrH m  BC�9�9 �:  G I�8I Z  H�JK�7LJ H  HPMM l HON�6�5N I HO�4�3O
�4 .DTpacd24bool    ��� null�3  O �2P�1
�2 
DTkbP o  JK�0�0 0 thedatabase theDatabase�1  �6  �5  K r  ScQRQ n SaSTS I  Ta�/U�.�/ 0 reporterror reportErrorU VWV o  TU�-�- 0 dbname dbNameW XYX I U\�,Z�+
�, .sysolocSutxt        TEXTZ l UX[�*�)[ m  UX\\ �]] ( O p t i m i z a t i o n   f a i l e d .�*  �)  �+  Y ^�(^ o  \]�'�' 0 failurecount failureCount�(  �.  T  f  STR o      �&�& 0 failurecount failureCount�7  L k  f�__ `a` I fq�%b�$
�% .DTpacd41bool    ��� utxtb l fmc�#�"c I fm�!d� 
�! .sysolocSutxt        TEXTd l fie��e m  fiff �gg  E x p o r t i n g &�  �  �   �#  �"  �$  a h�h Z  r�ij��i H  r�kk l r�l��l I r���m
� .DTpacd79bool    ��� null�  m �no
� 
DTkbn o  tu�� 0 thedatabase theDatabaseo �pq
� 
DTtop o  xy�� 0 savepath savePathq �r�
� 
DTifr m  |}�
� boovtrue�  �  �  j r  ��sts n ��uvu I  ���w�� 0 reporterror reportErrorw xyx o  ���� 0 dbname dbNamey z{z I ���|�
� .sysolocSutxt        TEXT| l ��}�
�	} m  ��~~ �  B a c k u p   f a i l e d .�
  �	  �  { ��� o  ���� 0 failurecount failureCount�  �  v  f  ��t o      �� 0 failurecount failureCount�  �  �  �8  �W   m  �� ��� I �����
� .sysodelanull��� ��� nmbr� m  ���� �  � ��� I ��� ����
�  .DTpacd43bool    ��� null��  ��  �  �� 0 thedatabase theDatabase � o   } ~���� 0 alldbs allDBs � ��� l ����������  ��  ��  � ��� I ������
�� .DTpacd80bool    ��� utxt� l �������� I �������
�� .sysolocSutxt        TEXT� l �������� m  ���� ��� , D a t a b a s e   b a c k u p s   d o n e .��  ��  ��  ��  ��  � �����
�� 
info� l �������� b  ����� b  ����� b  ����� l �������� c  ����� l �������� \  ����� l �������� I �������
�� .corecnte****       ****� o  ������ 0 alldbs allDBs��  ��  ��  � o  ������ 0 failurecount failureCount��  ��  � m  ����
�� 
TEXT��  ��  � l �������� I �������
�� .sysolocSutxt        TEXT� l �������� m  ���� ���    s u c c e e d e d .  ��  ��  ��  ��  ��  � o  ������ 0 failurecount failureCount� l �������� I �������
�� .sysolocSutxt        TEXT� c  ����� l �������� m  ���� ���    f a i l e d .��  ��  � m  ����
�� 
TEXT��  ��  ��  ��  ��  ��  � ���� Z ��������� o  ������ 0 
allowsound 
allowSound� n ����� I  ���������� 0 play  ��  ��  � l �������� n ����� I  ��������� 0 soundnamed_ soundNamed_� ���� o  ������ 0 succeedsound succeedSound��  ��  � o  ������ 0 thesound theSound��  ��  ��  ��  ��   W 5     �����
�� 
capp� m    �� ���  D N t p
�� kfrmID   T ��� l     ��������  ��  ��  � ��� i   = @��� I      ������� 0 zeropad  � ���� o      ���� 0 thenum theNum��  ��  � L     �� c     ��� n     ��� 7   ����
�� 
cha � m    	������� m   
 ������� l    ������ b     ��� m     �� ���  0� o    ���� 0 thenum theNum��  ��  � m    ��
�� 
TEXT� ��� l     ��������  ��  ��  � ���� i   A D��� I      ������� 0 reporterror reportError� ��� o      ���� 0 dbname dbName� ��� o      ���� 0 msg  � ���� o      ���� 0 failurecount failureCount��  ��  � k     4�� ��� Z    ������� o     ���� 0 
allowsound 
allowSound� n   ��� I    �������� 0 play  ��  ��  � l   ������ n   ��� I    ������� 0 soundnamed_ soundNamed_� ���� o    ���� 0 failuresound failureSound��  ��  � o    ���� 0 thesound theSound��  ��  ��  ��  � ��� O   /��� I  ' .����
�� .DTpacd80bool    ��� utxt� o   ' (���� 0 dbname dbName� �����
�� 
info� o   ) *���� 0 msg  ��  � 5    $�����
�� 
capp� m   ! "�� ���  D N t p
�� kfrmID  � ���� L   0 4�� l  0 3������ [   0 3��� o   0 1���� 0 failurecount failureCount� m   1 2���� ��  ��  ��  ��       ������� 2 7 <�������  � ����������������������
�� 
pimr�� 0 thesound theSound�� 0 
allowsound 
allowSound�� 0 failuresound failureSound�� 0 succeedsound succeedSound�� 0 
backupdest 
backupDest
�� .aevtoappnull  �   � ****�� "0 performreminder performReminder�� 0 	dobackups 	doBackups�� 0 zeropad  �� 0 reporterror reportError� ����� �  ��� �����
�� 
cobj� ��   �� !
�� 
frmk��  � �� ��
�� 
cobj     ��
�� 
osax��  �  ���
�� misccura� 0 nssound NSSound
�� boovfals� �~ F�}�|�{
�~ .aevtoappnull  �   � ****�}  �|     �z�y�z 0 	dobackups 	doBackups
�y .aevtoappnull  �   � ****�{ � *j U� �x N�w�v�u�x "0 performreminder performReminder�w  �v     �t�s�t 0 	dobackups 	doBackups
�s .aevtoappnull  �   � ****�u � *j U� �r U  �r 0 	dobackups 	doBackups  	 �q
�q .aevtoappnull  �   � ****	 �p
�o�n�m
�p .aevtoappnull  �   � ****
 k    � �l l   � U�k�j�k  �j  �l  �o  �n   �i�h�g�f�e�d�c�b�a�`�_�^�i 0 od  �h 0 alldbs allDBs�g 0 failurecount failureCount�f 0 y  �e 0 m  �d 0 d  �c 0 currentdate currentDate�b 0 thedatabase theDatabase�a 0 dbpath dbPath�` 0 dbnamewithext dbNameWithExt�_ 0 dbname dbName�^ 0 savepath savePath :�]��\�[�Z�Y�X�W�V�U�T�S�R�Q�P�O�N�M�L ��K�J�I�H ��G ��F � � ��E�D�C�B�A!�@�?:�>D�=\f�<�;�:~�9��8���7�6�5
�] 
capp
�\ kfrmID  
�[ .miscactvnull��� ��� null
�Z 
ascr
�Y 
txdl
�X 
DTkb
�W 
Krtn
�V 
year�U 0 y  
�T 
mnth�S 0 m  
�R 
day �Q 0 d  �P 
�O .misccurdldt    ��� null
�N 
long�M 0 zeropad  
�L 
cobj
�K 
TEXT
�J 
kocl
�I .corecnte****       ****
�H 
ppth
�G 
citm�F��
�E .sysolocSutxt        TEXT
�D 
DTsp
�C .DTpacd40bool       utxt
�B .sysodelanull��� ��� nmbr�A
�@ .DTpacd41bool    ��� utxt
�? .DTpacd29long    ��� null�> 0 reporterror reportError
�= .DTpacd24bool    ��� null
�< 
DTto
�; 
DTif
�: .DTpacd79bool    ��� null
�9 .DTpacd43bool    ��� null
�8 
info
�7 .DTpacd80bool    ��� utxt�6 0 soundnamed_ soundNamed_�5 0 play  �m�)���0�*j O��,E�O*�-E�OjE�O*��������l E[�,E�Z[�,E�Z[�,E�ZO)�a &k+ )�k+ lvE[a k/E�Z[a l/E�ZOa ��,FO���mva &E�O0�[a a l kh �a ,E�Oa ��,FO�a i/E�Oa ��,FO�[a \[Zk\Za 2a &E�O���,FOb  �%a %�%a %�%a %a &E�Oa j  �%a !ml "Okj #Oa $na %j  j &Okj #O*�l 'j )�a (j  �m+ )E�Y ea *j  j &Okj #O*�l + )�a ,j  �m+ )E�Y 5a -j  j &O*�a .�a /e� 0 )�a 1j  �m+ )E�Y hoOkj #O*j 2[OY��Oa 3j  a 4�j �a &a 5j  %�%a 6a &j  %l 7Ob   b  b  k+ 8j+ 9Y hU� �4��3�2�1�4 0 zeropad  �3 �0�0   �/�/ 0 thenum theNum�2   �.�. 0 thenum theNum ��-�,�+
�- 
cha �,��
�+ 
TEXT�1 �%[�\[Zi\Z�2�&� �*��)�(�'�* 0 reporterror reportError�) �&�&   �%�$�#�% 0 dbname dbName�$ 0 msg  �# 0 failurecount failureCount�(   �"�!� �" 0 dbname dbName�! 0 msg  �  0 failurecount failureCount �������� 0 soundnamed_ soundNamed_� 0 play  
� 
capp
� kfrmID  
� 
info
� .DTpacd80bool    ��� utxt�' 5b   b  b  k+  j+ Y hO)���0 	��l UO�k ascr  ��ޭ