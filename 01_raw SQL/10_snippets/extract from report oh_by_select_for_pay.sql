-- OH_BY_SELECT_FOR_PAY
-- Check of EFT information (Find a check or EFT, Check/EFT status report, OH- List of check's 
-- Open AP by Status, AP Check/EFT Register, Void Check Report
-- AP Check/EFT Register


--select * from glk_key_mstr
--select * from oh_div_mstr
select * 
from oh_dtl
right join oh_div_mstr ON oh_dtl.OH_DIV = oh_div_mstr.OH_DIV
right join glk_key_mstr ON oh_dtl.OH_GL_KEY = glk_key_mstr.GLK_KEY
where OH_Ck_dt >'12/31/2021'

