delete from filechurn where churn=0;
delete from filechurn where churn > 200 ;
delete from filechurn where filename like '%.jpg';
delete from filechurn where filename like '%.png';
delete from filechurn where filename like '%.gif';
delete from filechurn where filename like '%.tex';
delete from filechurn where filename like '%.svg';
delete from filechurn where filename like 'doc/%';
delete from filechurn where filename like 'docs/%';
delete from filechurn where filename like '%/doc/%';
delete from filechurn where filename like '%.doc';
delete from filechurn where filename like '%.docx';
-- forkexecd.git David Scott 2013-01-12 Remove everything but the fork/exec service rearrange file layout
delete from filechurn where uuid='fd78a7e421920f78c08679e3d21d15109b401a31';
