/*** Allard Group jun.allard@uci.edu                    ***/

// Performance Improvement #6: Use compatibility layer for optimized data access
#define USE_COMPATIBILITY_LAYER
#include "polymer_data_structures.h"

void initializeSummary();
void finalizeSummary(int reallyFinal);
void dataRecording();

/*******************************************************************************/
//  GLOBAL VARIABLES for output control
/*******************************************************************************/

double reeBar_sum[NFILMAX], ree2Bar_sum[NFILMAX], rMBar_sum[NFILMAX], rM2Bar_sum[NFILMAX], rMiSiteBar_sum[NFILMAX][NMAX], rM2iSiteBar_sum[NFILMAX][NMAX];
double reeiSiteBar_sum[NFILMAX][NMAX], ree2iSiteBar_sum[NFILMAX][NMAX];
double reeiSiteBar[NFILMAX][NMAX], ree2iSiteBar[NFILMAX][NMAX];

double reeFilBar_sum[NFILMAX][NFILMAX],ree2FilBar_sum[NFILMAX][NFILMAX];
double reeFilBar[NFILMAX][NFILMAX], ree2FilBar[NFILMAX][NFILMAX];

long POcclude_sum[NFILMAX][NMAX], POccludeBase_sum[NFILMAX], PDeliver_sum[NFILMAX][NMAX], PMembraneOcclude_sum[NFILMAX][NMAX],PMembraneSegmentOcclude_sum[NFILMAX][NMAX];

double reeBar[NFILMAX], ree2Bar[NFILMAX];
double POcclude[NFILMAX][NMAX], POccludeBase[NFILMAX];
double PDeliver[NFILMAX][NMAX], PMembraneOcclude[NFILMAX][NMAX],PMembraneSegmentOcclude[NFILMAX][NMAX];
double ree2iSite[NFILMAX][NMAX], rMBar[NFILMAX], rM2Bar[NFILMAX], rMiSiteBar[NFILMAX][NMAX], rM2iSiteBar[NFILMAX][NMAX];

double reeiSite[NFILMAX][NMAX]; // attachment site of same filament
double reeiSite_op[NFILMAX][NMAX]; // attachment site of opposite filament
double reeiSite_cen[NFILMAX][NMAX]; // center of of bases
double reeiSite_offcen[NFILMAX][NMAX]; // 2.5nm (8.333 aa) away from the center, towards the attachment site of same filament
double reeiSite_offcen_op[NFILMAX][NMAX]; // 2.5nm (8.333 aa) away from the center, towards the attachment site of opposite filament
double reeiSite_up[NFILMAX][NMAX]; // 5nm (16.666 aa) above the attachment site of same filament
double reeiSite_up_op[NFILMAX][NMAX]; // 5nm (16.666 aa) above the attachment site of opposite filament
double reeiSite_cen_up[NFILMAX][NMAX]; // 5nm (16.666 aa) above the center of of bases
double reeiSite_offcen_up[NFILMAX][NMAX]; // 5nm (16.666 aa) above and 2.5nm (8.333 aa) away from the center, towards the attachment site of same filament
double reeiSite_offcen_up_op[NFILMAX][NMAX]; // 5nm (16.666 aa) above and 2.5nm (8.333 aa) away from the center, towards the attachment site of opposite filament
double reeiSite_halfup[NFILMAX][NMAX]; // 2.5nm (8.333 aa) above the attachment site of same filament
double reeiSite_halfup_op[NFILMAX][NMAX]; // 2.5nm (8.333 aa) above the attachment site of opposite filament
double reeiSite_cen_halfup[NFILMAX][NMAX]; // 2.5nm (8.333 aa) above the center of of bases
double reeiSite_offcen_halfup[NFILMAX][NMAX]; // 2.5nm (8.333 aa) above and 2.5nm (8.333 aa) away from the center, towards the attachment site of same filament
double reeiSite_offcen_halfup_op[NFILMAX][NMAX]; // 2.5nm (8.333 aa) above and 2.5nm (8.333 aa) away from the center, towards the attachment site of opposite filament


long Prvec0_sum[NFILMAX][NMAX]; // attachment site of same filament
long Prvec0_op_sum[NFILMAX][NMAX]; // attachment site of opposite filament
long Prvec_cen_sum[NFILMAX][NMAX]; // center of of bases
long Prvec_offcen_sum[NFILMAX][NMAX]; // 2.5nm (8.333 aa) away from the center, towards the attachment site of same filament
long Prvec_offcen_op_sum[NFILMAX][NMAX]; // 2.5nm (8.333 aa) away from the center, towards the attachment site of opposite filament
long Prvec0_up_sum[NFILMAX][NMAX]; // 5nm (16.666 aa) above the attachment site of same filament
long Prvec0_up_op_sum[NFILMAX][NMAX]; // 5nm (16.666 aa) above the attachment site of opposite filament
long Prvec_cen_up_sum[NFILMAX][NMAX]; // 5nm (16.666 aa) above the center of of bases
long Prvec_offcen_up_sum[NFILMAX][NMAX]; // 5nm (16.666 aa) above and 2.5nm (8.333 aa) away from the center, towards the attachment site of same filament
long Prvec_offcen_up_op_sum[NFILMAX][NMAX]; // 5nm (16.666 aa) above and 2.5nm (8.333 aa) away from the center, towards the attachment site of opposite filament
long Prvec0_halfup_sum[NFILMAX][NMAX]; // 2.5nm (8.333 aa) above the attachment site of same filament
long Prvec0_halfup_op_sum[NFILMAX][NMAX]; // 2.5nm (8.333 aa) above the attachment site of opposite filament
long Prvec_cen_halfup_sum[NFILMAX][NMAX]; // 2.5nm (8.333 aa) above the center of of bases
long Prvec_offcen_halfup_sum[NFILMAX][NMAX]; // 2.5nm (8.333 aa) above and 2.5nm (8.333 aa) away from the center, towards the attachment site of same filament
long Prvec_offcen_halfup_op_sum[NFILMAX][NMAX]; // 2.5nm (8.333 aa) above and 2.5nm (8.333 aa) away from the center, towards the attachment site of opposite filament

double Prvec0[NFILMAX][NMAX]; // attachment site of same filament
double Prvec0_op[NFILMAX][NMAX]; // attachment site of opposite filament
double Prvec_cen[NFILMAX][NMAX]; // center of of bases
double Prvec_offcen[NFILMAX][NMAX]; // 2.5nm (8.333 aa) away from the center, towards the attachment site of same filament
double Prvec_offcen_op[NFILMAX][NMAX]; // 2.5nm (8.333 aa) away from the center, towards the attachment site of opposite filament
double Prvec0_up[NFILMAX][NMAX]; // 5nm (16.666 aa) above the attachment site of same filament
double Prvec0_up_op[NFILMAX][NMAX]; // 5nm (16.666 aa) above the attachment site of opposite filament
double Prvec_cen_up[NFILMAX][NMAX]; // 5nm (16.666 aa) above the center of of bases
double Prvec_offcen_up[NFILMAX][NMAX]; // 5nm (16.666 aa) above and 2.5nm (8.333 aa) away from the center, towards the attachment site of same filament
double Prvec_offcen_up_op[NFILMAX][NMAX]; // 5nm (16.666 aa) above and 2.5nm (8.333 aa) away from the center, towards the attachment site of opposite filament
double Prvec0_halfup[NFILMAX][NMAX]; // 2.5nm (8.333 aa) above the attachment site of same filament
double Prvec0_halfup_op[NFILMAX][NMAX]; // 2.5nm (8.333 aa) above the attachment site of opposite filament
double Prvec_cen_halfup[NFILMAX][NMAX]; // 2.5nm (8.333 aa) above the center of of bases
double Prvec_offcen_halfup[NFILMAX][NMAX]; // 2.5nm (8.333 aa) above and 2.5nm (8.333 aa) away from the center, towards the attachment site of same filament
double Prvec_offcen_halfup_op[NFILMAX][NMAX]; // 2.5nm (8.333 aa) above and 2.5nm (8.333 aa) away from the center, towards the attachment site of opposite filament

// The radius used to compute the test volume for probability densities:
double Prvec0_rad[NFILMAX][NMAX]; // attachment site of same filament
double Prvec0_op_rad[NFILMAX][NMAX]; // attachment site of opposite filament
double Prvec_cen_rad[NFILMAX][NMAX]; // center of of bases
double Prvec_offcen_rad[NFILMAX][NMAX]; // 2.5nm (8.333 aa) away from the center, towards the attachment site of same filament
double Prvec_offcen_op_rad[NFILMAX][NMAX]; // 2.5nm (8.333 aa) away from the center, towards the attachment site of opposite filament
double Prvec0_up_rad[NFILMAX][NMAX]; // 5nm (16.666 aa) above the attachment site of same filament
double Prvec0_up_op_rad[NFILMAX][NMAX]; // 5nm (16.666 aa) above the attachment site of opposite filament
double Prvec_cen_up_rad[NFILMAX][NMAX]; // 5nm (16.666 aa) above the center of of bases
double Prvec_offcen_up_rad[NFILMAX][NMAX]; // 5nm (16.666 aa) above and 2.5nm (8.333 aa) away from the center, towards the attachment site of same filament
double Prvec_offcen_up_op_rad[NFILMAX][NMAX]; // 5nm (16.666 aa) above and 2.5nm (8.333 aa) away from the center, towards the attachment site of opposite filament
double Prvec0_halfup_rad[NFILMAX][NMAX]; // 2.5nm (8.333 aa) above the attachment site of same filament
double Prvec0_halfup_op_rad[NFILMAX][NMAX]; // 2.5nm (8.333 aa) above the attachment site of opposite filament
double Prvec_cen_halfup_rad[NFILMAX][NMAX]; // 2.5nm (8.333 aa) above the center of of bases
double Prvec_offcen_halfup_rad[NFILMAX][NMAX]; // 2.5nm (8.333 aa) above and 2.5nm (8.333 aa) away from the center, towards the attachment site of same filament
double Prvec_offcen_halfup_op_rad[NFILMAX][NMAX]; // 2.5nm (8.333 aa) above and 2.5nm (8.333 aa) away from the center, towards the attachment site of opposite filament

float Prvec_rad_vec[5]={ 0.1,0.5,0.75,1.0,4.0}; // radius values to use in following vectors
double Prvec_rad_vec_size=5;

long Prvec0_sum_vec[NFILMAX][NMAX][10]; // attachment site of same filament
long Prvec0_op_sum_vec[NFILMAX][NMAX][10]; // attachment site of opposite filament
long Prvec_cen_sum_vec[NFILMAX][NMAX][10]; // center of of bases
long Prvec_offcen_sum_vec[NFILMAX][NMAX][10]; // 2.5nm (8.333 aa) away from the center, towards the attachment site of same filament
long Prvec_offcen_op_sum_vec[NFILMAX][NMAX][10]; // 2.5nm (8.333 aa) away from the center, towards the attachment site of opposite filament
long Prvec0_up_sum_vec[NFILMAX][NMAX][10]; // 5nm (16.666 aa) above the attachment site of same filament
long Prvec0_up_op_sum_vec[NFILMAX][NMAX][10]; // 5nm (16.666 aa) above the attachment site of opposite filament
long Prvec_cen_up_sum_vec[NFILMAX][NMAX][10]; // 5nm (16.666 aa) above the center of of bases
long Prvec_offcen_up_sum_vec[NFILMAX][NMAX][10]; // 5nm (16.666 aa) above and 2.5nm (8.333 aa) away from the center, towards the attachment site of same filament
long Prvec_offcen_up_op_sum_vec[NFILMAX][NMAX][10]; // 5nm (16.666 aa) above and 2.5nm (8.333 aa) away from the center, towards the attachment site of opposite filament
long Prvec0_halfup_sum_vec[NFILMAX][NMAX][10]; // 2.5nm (8.333 aa) above the attachment site of same filament
long Prvec0_halfup_op_sum_vec[NFILMAX][NMAX][10]; // 2.5nm (8.333 aa) above the attachment site of opposite filament
long Prvec_cen_halfup_sum_vec[NFILMAX][NMAX][10]; // 2.5nm (8.333 aa) above the center of of bases
long Prvec_offcen_halfup_sum_vec[NFILMAX][NMAX][10]; // 2.5nm (8.333 aa) above and 2.5nm (8.333 aa) away from the center, towards the attachment site of same filament
long Prvec_offcen_halfup_op_sum_vec[NFILMAX][NMAX][10]; // 2.5nm (8.333 aa) above and 2.5nm (8.333 aa) away from the center, towards the attachment site of opposite filament

double Prvec0_vec[NFILMAX][NMAX][10]; // attachment site of same filament
double Prvec0_op_vec[NFILMAX][NMAX][10]; // attachment site of opposite filament
double Prvec_cen_vec[NFILMAX][NMAX][10]; // center of of bases
double Prvec_offcen_vec[NFILMAX][NMAX][10]; // 2.5nm (8.333 aa) away from the center, towards the attachment site of same filament
double Prvec_offcen_op_vec[NFILMAX][NMAX][10]; // 2.5nm (8.333 aa) away from the center, towards the attachment site of opposite filament
double Prvec0_up_vec[NFILMAX][NMAX][10]; // 5nm (16.666 aa) above the attachment site of same filament
double Prvec0_up_op_vec[NFILMAX][NMAX][10]; // 5nm (16.666 aa) above the attachment site of opposite filament
double Prvec_cen_up_vec[NFILMAX][NMAX][10]; // 5nm (16.666 aa) above the center of of bases
double Prvec_offcen_up_vec[NFILMAX][NMAX][10]; // 5nm (16.666 aa) above and 2.5nm (8.333 aa) away from the center, towards the attachment site of same filament
double Prvec_offcen_up_op_vec[NFILMAX][NMAX][10]; // 5nm (16.666 aa) above and 2.5nm (8.333 aa) away from the center, towards the attachment site of opposite filament
double Prvec0_halfup_vec[NFILMAX][NMAX][10]; // 2.5nm (8.333 aa) above the attachment site of same filament
double Prvec0_halfup_op_vec[NFILMAX][NMAX][10]; // 2.5nm (8.333 aa) above the attachment site of opposite filament
double Prvec_cen_halfup_vec[NFILMAX][NMAX][10]; // 2.5nm (8.333 aa) above the center of of bases
double Prvec_offcen_halfup_vec[NFILMAX][NMAX][10]; // 2.5nm (8.333 aa) above and 2.5nm (8.333 aa) away from the center, towards the attachment site of same filament
double Prvec_offcen_halfup_op_vec[NFILMAX][NMAX][10]; // 2.5nm (8.333 aa) above and 2.5nm (8.333 aa) away from the center, towards the attachment site of opposite filament

// For bound sites:
double reeiSite_bound[NFILMAX][NMAX][2]; // attachment site of same filament
double reeiSite_op_bound[NFILMAX][NMAX][2]; // attachment site of opposite filament
double reeiSite_cen_bound[NFILMAX][NMAX][2]; // center of of bases
double reeiSite_offcen_bound[NFILMAX][NMAX][2]; // 2.5nm (8.333 aa) away from the center, towards the attachment site of same filament
double reeiSite_offcen_op_bound[NFILMAX][NMAX][2]; // 2.5nm (8.333 aa) away from the center, towards the attachment site of opposite filament
double reeiSite_up_bound[NFILMAX][NMAX][2]; // 5nm (16.666 aa) above the attachment site of same filament
double reeiSite_up_op_bound[NFILMAX][NMAX][2]; // 5nm (16.666 aa) above the attachment site of opposite filament
double reeiSite_cen_up_bound[NFILMAX][NMAX][2]; // 5nm (16.666 aa) above the center of of bases
double reeiSite_offcen_up_bound[NFILMAX][NMAX][2]; // 5nm (16.666 aa) above and 2.5nm (8.333 aa) away from the center, towards the attachment site of same filament
double reeiSite_offcen_up_op_bound[NFILMAX][NMAX][2]; // 5nm (16.666 aa) above and 2.5nm (8.333 aa) away from the center, towards the attachment site of opposite filament
double reeiSite_halfup_bound[NFILMAX][NMAX][2]; // 2.5nm (8.333 aa) above the attachment site of same filament
double reeiSite_halfup_op_bound[NFILMAX][NMAX][2]; // 2.5nm (8.333 aa) above the attachment site of opposite filament
double reeiSite_cen_halfup_bound[NFILMAX][NMAX][2]; // 2.5nm (8.333 aa) above the center of of bases
double reeiSite_offcen_halfup_bound[NFILMAX][NMAX][2]; // 2.5nm (8.333 aa) above and 2.5nm (8.333 aa) away from the center, towards the attachment site of same filament
double reeiSite_offcen_halfup_op_bound[NFILMAX][NMAX][2]; // 2.5nm (8.333 aa) above and 2.5nm (8.333 aa) away from the center, towards the attachment site of opposite filament


long Prvec0_sum_bound[NFILMAX][NMAX][2]; // attachment site of same filament
long Prvec0_op_sum_bound[NFILMAX][NMAX][2]; // attachment site of opposite filament
long Prvec_cen_sum_bound[NFILMAX][NMAX][2]; // center of of bases
long Prvec_offcen_sum_bound[NFILMAX][NMAX][2]; // 2.5nm (8.333 aa) away from the center, towards the attachment site of same filament
long Prvec_offcen_op_sum_bound[NFILMAX][NMAX][2]; // 2.5nm (8.333 aa) away from the center, towards the attachment site of opposite filament
long Prvec0_up_sum_bound[NFILMAX][NMAX][2]; // 5nm (16.666 aa) above the attachment site of same filament
long Prvec0_up_op_sum_bound[NFILMAX][NMAX][2]; // 5nm (16.666 aa) above the attachment site of opposite filament
long Prvec_cen_up_sum_bound[NFILMAX][NMAX][2]; // 5nm (16.666 aa) above the center of of bases
long Prvec_offcen_up_sum_bound[NFILMAX][NMAX][2]; // 5nm (16.666 aa) above and 2.5nm (8.333 aa) away from the center, towards the attachment site of same filament
long Prvec_offcen_up_op_sum_bound[NFILMAX][NMAX][2]; // 5nm (16.666 aa) above and 2.5nm (8.333 aa) away from the center, towards the attachment site of opposite filament
long Prvec0_halfup_sum_bound[NFILMAX][NMAX][2]; // 2.5nm (8.333 aa) above the attachment site of same filament
long Prvec0_halfup_op_sum_bound[NFILMAX][NMAX][2]; // 2.5nm (8.333 aa) above the attachment site of opposite filament
long Prvec_cen_halfup_sum_bound[NFILMAX][NMAX][2]; // 2.5nm (8.333 aa) above the center of of bases
long Prvec_offcen_halfup_sum_bound[NFILMAX][NMAX][2]; // 2.5nm (8.333 aa) above and 2.5nm (8.333 aa) away from the center, towards the attachment site of same filament
long Prvec_offcen_halfup_op_sum_bound[NFILMAX][NMAX][2]; // 2.5nm (8.333 aa) above and 2.5nm (8.333 aa) away from the center, towards the attachment site of opposite filament

double Prvec0_bound[NFILMAX][NMAX][2]; // attachment site of same filament
double Prvec0_op_bound[NFILMAX][NMAX][2]; // attachment site of opposite filament
double Prvec_cen_bound[NFILMAX][NMAX][2]; // center of of bases
double Prvec_offcen_bound[NFILMAX][NMAX][2]; // 2.5nm (8.333 aa) away from the center, towards the attachment site of same filament
double Prvec_offcen_op_bound[NFILMAX][NMAX][2]; // 2.5nm (8.333 aa) away from the center, towards the attachment site of opposite filament
double Prvec0_up_bound[NFILMAX][NMAX][2]; // 5nm (16.666 aa) above the attachment site of same filament
double Prvec0_up_op_bound[NFILMAX][NMAX][2]; // 5nm (16.666 aa) above the attachment site of opposite filament
double Prvec_cen_up_bound[NFILMAX][NMAX][2]; // 5nm (16.666 aa) above the center of of bases
double Prvec_offcen_up_bound[NFILMAX][NMAX][2]; // 5nm (16.666 aa) above and 2.5nm (8.333 aa) away from the center, towards the attachment site of same filament
double Prvec_offcen_up_op_bound[NFILMAX][NMAX][2]; // 5nm (16.666 aa) above and 2.5nm (8.333 aa) away from the center, towards the attachment site of opposite filament
double Prvec0_halfup_bound[NFILMAX][NMAX][2]; // 2.5nm (8.333 aa) above the attachment site of same filament
double Prvec0_halfup_op_bound[NFILMAX][NMAX][2]; // 2.5nm (8.333 aa) above the attachment site of opposite filament
double Prvec_cen_halfup_bound[NFILMAX][NMAX][2]; // 2.5nm (8.333 aa) above the center of of bases
double Prvec_offcen_halfup_bound[NFILMAX][NMAX][2]; // 2.5nm (8.333 aa) above and 2.5nm (8.333 aa) away from the center, towards the attachment site of same filament
double Prvec_offcen_halfup_op_bound[NFILMAX][NMAX][2]; // 2.5nm (8.333 aa) above and 2.5nm (8.333 aa) away from the center, towards the attachment site of opposite filament

//

double distiSiteToLigand[NFILMAX][NMAX][NMAX], selfBind[NFILMAX][NMAX][NMAX], selfBindFraction[NFILMAX][NMAX][NMAX], localConcentration[NFILMAX][NMAX][NMAX];

double binSize[NFILMAX];
long binCurrent;

double iSitesOccluded_counter;
double POcclude_NumSites[NMAX], POcclude_NumSites_sum[NMAX], PAvailable_NumSites[NMAX];


/********************************************************************************************************/
void initializeSummary()
{

    // summary variables
    for(nf=0;nf<NFil;nf++)
    {
        reeBar_sum[nf]   = 0;
        ree2Bar_sum[nf]  = 0;

        for(nf2=0;nf2<NFil;nf2++)
        {
            reeFilBar_sum[nf][nf2] = 0;
            ree2FilBar_sum[nf][nf2] = 0;
        }

        for(iy=0;iy<iSiteTotal[nf];iy++)
        {
            POcclude_sum[nf][iy]                = 0;
            Prvec0_sum[nf][iy]                  = 0;
            PMembraneOcclude_sum[nf][iy]        = 0;

            Prvec0_up_sum[nf][iy]           = 0;
            Prvec0_halfup_sum[nf][iy]           = 0;
            Prvec0_op_sum[nf][iy]           = 0;
            
            Prvec_cen_sum[nf][iy]           = 0;
            Prvec_offcen_sum[nf][iy]           = 0;
            Prvec_offcen_op_sum[nf][iy]           = 0;

            Prvec0_up_op_sum[nf][iy]           = 0;
            Prvec_cen_up_sum[nf][iy]           = 0;
            Prvec_offcen_up_sum[nf][iy]           = 0;
            Prvec_offcen_up_op_sum[nf][iy]           = 0;

            Prvec0_halfup_op_sum[nf][iy]           = 0;
            Prvec_cen_halfup_sum[nf][iy]           = 0;
            Prvec_offcen_halfup_sum[nf][iy]           = 0;
            Prvec_offcen_halfup_op_sum[nf][iy]           = 0;


            Prvec0_sum_bound[nf][iy][0]                  = 0;
            Prvec0_up_sum_bound[nf][iy][0]           = 0;
            Prvec0_halfup_sum_bound[nf][iy][0]           = 0;
            Prvec0_op_sum_bound[nf][iy][0]           = 0;
            
            Prvec_cen_sum_bound[nf][iy][0]           = 0;
            Prvec_offcen_sum_bound[nf][iy][0]           = 0;
            Prvec_offcen_op_sum_bound[nf][iy][0]           = 0;

            Prvec0_up_op_sum_bound[nf][iy][0]           = 0;
            Prvec_cen_up_sum_bound[nf][iy][0]           = 0;
            Prvec_offcen_up_sum_bound[nf][iy][0]           = 0;
            Prvec_offcen_up_op_sum_bound[nf][iy][0]           = 0;

            Prvec0_halfup_op_sum_bound[nf][iy][0]           = 0;
            Prvec_cen_halfup_sum_bound[nf][iy][0]           = 0;
            Prvec_offcen_halfup_sum_bound[nf][iy][0]           = 0;
            Prvec_offcen_halfup_op_sum_bound[nf][iy][0]           = 0;

            Prvec0_sum_bound[nf][iy][1]                  = 0;
            Prvec0_up_sum_bound[nf][iy][1]           = 0;
            Prvec0_halfup_sum_bound[nf][iy][1]           = 0;
            Prvec0_op_sum_bound[nf][iy][1]           = 0;
            
            Prvec_cen_sum_bound[nf][iy][1]           = 0;
            Prvec_offcen_sum_bound[nf][iy][1]           = 0;
            Prvec_offcen_op_sum_bound[nf][iy][1]           = 0;

            Prvec0_up_op_sum_bound[nf][iy][1]           = 0;
            Prvec_cen_up_sum_bound[nf][iy][1]           = 0;
            Prvec_offcen_up_sum_bound[nf][iy][1]           = 0;
            Prvec_offcen_up_op_sum_bound[nf][iy][1]           = 0;

            Prvec0_halfup_op_sum_bound[nf][iy][1]           = 0;
            Prvec_cen_halfup_sum_bound[nf][iy][1]           = 0;
            Prvec_offcen_halfup_sum_bound[nf][iy][1]           = 0;
            Prvec_offcen_halfup_op_sum_bound[nf][iy][1]           = 0;

            for(j=0;j<10;j++)
            {
                Prvec0_up_sum_vec[nf][iy][j]           = 0;
                Prvec0_halfup_sum_vec[nf][iy][j]           = 0;
                Prvec0_op_sum_vec[nf][iy][j]           = 0;
                
                Prvec_cen_sum_vec[nf][iy][j]           = 0;
                Prvec_offcen_sum_vec[nf][iy][j]           = 0;
                Prvec_offcen_op_sum_vec[nf][iy][j]           = 0;

                Prvec0_up_op_sum_vec[nf][iy][j]           = 0;
                Prvec_cen_up_sum_vec[nf][iy][j]           = 0;
                Prvec_offcen_up_sum_vec[nf][iy][j]           = 0;
                Prvec_offcen_up_op_sum_vec[nf][iy][j]           = 0;

                Prvec0_halfup_op_sum_vec[nf][iy][j]           = 0;
                Prvec_cen_halfup_sum_vec[nf][iy][j]           = 0;
                Prvec_offcen_halfup_sum_vec[nf][iy][j]           = 0;
                Prvec_offcen_halfup_op_sum_vec[nf][iy][j]           = 0;
            }
                
        }
        POccludeBase_sum[nf] = 0;

        rMBar_sum[nf]    = 0;
        rM2Bar_sum[nf]   = 0;

        //distance of iSites to membrane
        for (iy=0;iy<iSiteTotal[nf];iy++)
        {
            reeiSiteBar_sum[nf][iy] = 0;
            ree2iSiteBar_sum[nf][iy] = 0;

            rMiSiteBar_sum[nf][iy] = 0;
            rM2iSiteBar_sum[nf][iy] = 0;
        }
    }

    for(i=0;i<=NumberiSites;i++)
    {
        POcclude_NumSites[i] = 0;
    }


    for(nf=0;nf<NFil;nf++)
    {
        binSize[nf] = (double)(2*N[nf]) / NBINSPOLYMER;
    }

    if(MULTIPLE)
    {
        for(nf=0;nf<NFil;nf++)
        {
            for(iy=0; iy<iSiteTotal[nf]; iy++)
            {
                for(ib=0; ib<bSiteTotal[nf]; ib++)
                {
                    distiSiteToLigand[nf][iy][ib]  = 0;
                    selfBind[nf][iy][ib]           = 0;
                    selfBindFraction[nf][iy][ib]   = 0;
                    localConcentration[nf][iy][ib] = 0;
                }
            }
        }
    }

}

/********************************************************************************************************/
void finalizeSummary(int reallyFinal)
{
    // finalize summary statistics
    for(nf=0;nf<NFil;nf++)
    {
        reeBar[nf]  = reeBar_sum[nf]/(double)(nt-NTCHECK);
        ree2Bar[nf] = ree2Bar_sum[nf]/(double)(nt-NTCHECK);

        for(nf2=0;nf2<NFil;nf2++)
        {
            reeFilBar[nf][nf2] = reeFilBar_sum[nf][nf2]/(double)(nt-NTCHECK);
            ree2FilBar[nf][nf2] = ree2FilBar_sum[nf][nf2]/(double)(nt-NTCHECK);
        }

        for(iy=0;iy<iSiteTotal[nf];iy++)
        {
            POcclude[nf][iy]         = (double)POcclude_sum[nf][iy]/(double)(nt-NTCHECK);
            PMembraneOcclude[nf][iy] = (double)PMembraneOcclude_sum[nf][iy]/(double)(nt-NTCHECK);
            PMembraneSegmentOcclude[nf][iy] = (double)PMembraneSegmentOcclude_sum[nf][iy]/(double)(nt-NTCHECK);

            Prvec0[nf][iy]           = (double)Prvec0_sum[nf][iy]/(4/3*PI*pow((double)Prvec0_rad[nf][iy],3))/(double)(nt-NTCHECK);
            Prvec0_up[nf][iy]        = (double)Prvec0_up_sum[nf][iy]/(4/3*PI*pow((double)Prvec0_up_rad[nf][iy],3))/(double)(nt-NTCHECK);
            Prvec0_halfup[nf][iy]        = (double)Prvec0_halfup_sum[nf][iy]/(4/3*PI*pow((double)Prvec0_halfup_rad[nf][iy],3))/(double)(nt-NTCHECK);

            Prvec0_bound[nf][iy][0]           = (double)Prvec0_sum_bound[nf][iy][0]/(4/3*PI*pow((double)Prvec0_rad[nf][iy],3))/(double)(nt-NTCHECK);
            Prvec0_up_bound[nf][iy][0]        = (double)Prvec0_up_sum_bound[nf][iy][0]/(4/3*PI*pow((double)Prvec0_up_rad[nf][iy],3))/(double)(nt-NTCHECK);
            Prvec0_halfup_bound[nf][iy][0]        = (double)Prvec0_halfup_sum_bound[nf][iy][0]/(4/3*PI*pow((double)Prvec0_halfup_rad[nf][iy],3))/(double)(nt-NTCHECK);

            Prvec0_bound[nf][iy][1]           = (double)Prvec0_sum_bound[nf][iy][1]/(4/3*PI*pow((double)Prvec0_rad[nf][iy],3))/(double)(nt-NTCHECK);
            Prvec0_up_bound[nf][iy][1]        = (double)Prvec0_up_sum_bound[nf][iy][1]/(4/3*PI*pow((double)Prvec0_up_rad[nf][iy],3))/(double)(nt-NTCHECK);
            Prvec0_halfup_bound[nf][iy][1]        = (double)Prvec0_halfup_sum_bound[nf][iy][1]/(4/3*PI*pow((double)Prvec0_halfup_rad[nf][iy],3))/(double)(nt-NTCHECK);

                if(NFil<=2){
                    Prvec0_op[nf][iy]           = (double)Prvec0_op_sum[nf][iy]/(4/3*PI*pow((double)Prvec0_op_rad[nf][iy],3))/(double)(nt-NTCHECK);
                    Prvec_cen[nf][iy]           = (double)Prvec_cen_sum[nf][iy]/(4/3*PI*pow((double)Prvec_cen_rad[nf][iy],3))/(double)(nt-NTCHECK);
                    Prvec_offcen[nf][iy]           = (double)Prvec_offcen_sum[nf][iy]/(4/3*PI*pow((double)Prvec_offcen_rad[nf][iy],3))/(double)(nt-NTCHECK);
                    Prvec_offcen_op[nf][iy]           = (double)Prvec_offcen_op_sum[nf][iy]/(4/3*PI*pow((double)Prvec_offcen_op_rad[nf][iy],3))/(double)(nt-NTCHECK);
                    Prvec0_up_op[nf][iy]           = (double)Prvec0_up_op_sum[nf][iy]/(4/3*PI*pow((double)Prvec0_up_op_rad[nf][iy],3))/(double)(nt-NTCHECK);
                    Prvec_cen_up[nf][iy]           = (double)Prvec_cen_up_sum[nf][iy]/(4/3*PI*pow((double)Prvec_cen_up_rad[nf][iy],3))/(double)(nt-NTCHECK);
                    Prvec_offcen_up[nf][iy]           = (double)Prvec_offcen_up_sum[nf][iy]/(4/3*PI*pow((double)Prvec_offcen_up_rad[nf][iy],3))/(double)(nt-NTCHECK);
                    Prvec_offcen_up_op[nf][iy]           = (double)Prvec_offcen_up_op_sum[nf][iy]/(4/3*PI*pow((double)Prvec_offcen_up_op_rad[nf][iy],3))/(double)(nt-NTCHECK);

                    Prvec0_halfup_op[nf][iy]           = (double)Prvec0_halfup_op_sum[nf][iy]/(4/3*PI*pow((double)Prvec0_halfup_op_rad[nf][iy],3))/(double)(nt-NTCHECK);
                    Prvec_cen_halfup[nf][iy]           = (double)Prvec_cen_halfup_sum[nf][iy]/(4/3*PI*pow((double)Prvec_cen_halfup_rad[nf][iy],3))/(double)(nt-NTCHECK);
                    Prvec_offcen_halfup[nf][iy]           = (double)Prvec_offcen_halfup_sum[nf][iy]/(4/3*PI*pow((double)Prvec_offcen_halfup_rad[nf][iy],3))/(double)(nt-NTCHECK);
                    Prvec_offcen_halfup_op[nf][iy]           = (double)Prvec_offcen_halfup_op_sum[nf][iy]/(4/3*PI*pow((double)Prvec_offcen_halfup_op_rad[nf][iy],3))/(double)(nt-NTCHECK);

                    Prvec0_op_bound[nf][iy][0]           = (double)Prvec0_op_sum_bound[nf][iy][0]/(4/3*PI*pow((double)Prvec0_op_rad[nf][iy],3))/(double)(nt-NTCHECK);
                    Prvec_cen_bound[nf][iy][0]           = (double)Prvec_cen_sum_bound[nf][iy][0]/(4/3*PI*pow((double)Prvec_cen_rad[nf][iy],3))/(double)(nt-NTCHECK);
                    Prvec_offcen_bound[nf][iy][0]           = (double)Prvec_offcen_sum_bound[nf][iy][0]/(4/3*PI*pow((double)Prvec_offcen_rad[nf][iy],3))/(double)(nt-NTCHECK);
                    Prvec_offcen_op_bound[nf][iy][0]           = (double)Prvec_offcen_op_sum_bound[nf][iy][0]/(4/3*PI*pow((double)Prvec_offcen_op_rad[nf][iy],3))/(double)(nt-NTCHECK);
                    Prvec0_up_op_bound[nf][iy][0]           = (double)Prvec0_up_op_sum_bound[nf][iy][0]/(4/3*PI*pow((double)Prvec0_up_op_rad[nf][iy],3))/(double)(nt-NTCHECK);
                    Prvec_cen_up_bound[nf][iy][0]           = (double)Prvec_cen_up_sum_bound[nf][iy][0]/(4/3*PI*pow((double)Prvec_cen_up_rad[nf][iy],3))/(double)(nt-NTCHECK);
                    Prvec_offcen_up_bound[nf][iy][0]           = (double)Prvec_offcen_up_sum_bound[nf][iy][0]/(4/3*PI*pow((double)Prvec_offcen_up_rad[nf][iy],3))/(double)(nt-NTCHECK);
                    Prvec_offcen_up_op_bound[nf][iy][0]           = (double)Prvec_offcen_up_op_sum_bound[nf][iy][0]/(4/3*PI*pow((double)Prvec_offcen_up_op_rad[nf][iy],3))/(double)(nt-NTCHECK);

                    Prvec0_halfup_op_bound[nf][iy][0]           = (double)Prvec0_halfup_op_sum_bound[nf][iy][0]/(4/3*PI*pow((double)Prvec0_halfup_op_rad[nf][iy],3))/(double)(nt-NTCHECK);
                    Prvec_cen_halfup_bound[nf][iy][0]           = (double)Prvec_cen_halfup_sum_bound[nf][iy][0]/(4/3*PI*pow((double)Prvec_cen_halfup_rad[nf][iy],3))/(double)(nt-NTCHECK);
                    Prvec_offcen_halfup_bound[nf][iy][0]           = (double)Prvec_offcen_halfup_sum_bound[nf][iy][0]/(4/3*PI*pow((double)Prvec_offcen_halfup_rad[nf][iy],3))/(double)(nt-NTCHECK);
                    Prvec_offcen_halfup_op_bound[nf][iy][0]           = (double)Prvec_offcen_halfup_op_sum_bound[nf][iy][0]/(4/3*PI*pow((double)Prvec_offcen_halfup_op_rad[nf][iy],3))/(double)(nt-NTCHECK);

                    Prvec0_op_bound[nf][iy][1]           = (double)Prvec0_op_sum_bound[nf][iy][1]/(4/3*PI*pow((double)Prvec0_op_rad[nf][iy],3))/(double)(nt-NTCHECK);
                    Prvec_cen_bound[nf][iy][1]           = (double)Prvec_cen_sum_bound[nf][iy][1]/(4/3*PI*pow((double)Prvec_cen_rad[nf][iy],3))/(double)(nt-NTCHECK);
                    Prvec_offcen_bound[nf][iy][1]           = (double)Prvec_offcen_sum_bound[nf][iy][1]/(4/3*PI*pow((double)Prvec_offcen_rad[nf][iy],3))/(double)(nt-NTCHECK);
                    Prvec_offcen_op_bound[nf][iy][1]           = (double)Prvec_offcen_op_sum_bound[nf][iy][1]/(4/3*PI*pow((double)Prvec_offcen_op_rad[nf][iy],3))/(double)(nt-NTCHECK);
                    Prvec0_up_op_bound[nf][iy][1]           = (double)Prvec0_up_op_sum_bound[nf][iy][1]/(4/3*PI*pow((double)Prvec0_up_op_rad[nf][iy],3))/(double)(nt-NTCHECK);
                    Prvec_cen_up_bound[nf][iy][1]           = (double)Prvec_cen_up_sum_bound[nf][iy][1]/(4/3*PI*pow((double)Prvec_cen_up_rad[nf][iy],3))/(double)(nt-NTCHECK);
                    Prvec_offcen_up_bound[nf][iy][1]           = (double)Prvec_offcen_up_sum_bound[nf][iy][1]/(4/3*PI*pow((double)Prvec_offcen_up_rad[nf][iy],3))/(double)(nt-NTCHECK);
                    Prvec_offcen_up_op_bound[nf][iy][1]           = (double)Prvec_offcen_up_op_sum_bound[nf][iy][1]/(4/3*PI*pow((double)Prvec_offcen_up_op_rad[nf][iy],3))/(double)(nt-NTCHECK);

                    Prvec0_halfup_op_bound[nf][iy][1]           = (double)Prvec0_halfup_op_sum_bound[nf][iy][1]/(4/3*PI*pow((double)Prvec0_halfup_op_rad[nf][iy],3))/(double)(nt-NTCHECK);
                    Prvec_cen_halfup_bound[nf][iy][1]           = (double)Prvec_cen_halfup_sum_bound[nf][iy][1]/(4/3*PI*pow((double)Prvec_cen_halfup_rad[nf][iy],3))/(double)(nt-NTCHECK);
                    Prvec_offcen_halfup_bound[nf][iy][1]           = (double)Prvec_offcen_halfup_sum_bound[nf][iy][1]/(4/3*PI*pow((double)Prvec_offcen_halfup_rad[nf][iy],3))/(double)(nt-NTCHECK);
                    Prvec_offcen_halfup_op_bound[nf][iy][1]           = (double)Prvec_offcen_halfup_op_sum_bound[nf][iy][1]/(4/3*PI*pow((double)Prvec_offcen_halfup_op_rad[nf][iy],3))/(double)(nt-NTCHECK);
                }
            for (j=0;j<Prvec_rad_vec_size;j++)
            {
                Prvec0_vec[nf][iy][j]           = (double)Prvec0_sum_vec[nf][iy][j]/(4/3*PI*pow((double)Prvec_rad_vec[j],3))/(double)(nt-NTCHECK);
                Prvec0_up_vec[nf][iy][j]        = (double)Prvec0_up_sum_vec[nf][iy][j]/(4/3*PI*pow((double)Prvec_rad_vec[j],3))/(double)(nt-NTCHECK);
                Prvec0_halfup_vec[nf][iy][j]        = (double)Prvec0_halfup_sum_vec[nf][iy][j]/(4/3*PI*pow((double)Prvec_rad_vec[j],3))/(double)(nt-NTCHECK);

                    if(NFil<=2){
                        Prvec0_op_vec[nf][iy][j]           = (double)Prvec0_op_sum_vec[nf][iy][j]/(4/3*PI*pow((double)Prvec_rad_vec[j],3))/(double)(nt-NTCHECK);
                        Prvec_cen_vec[nf][iy][j]           = (double)Prvec_cen_sum_vec[nf][iy][j]/(4/3*PI*pow((double)Prvec_rad_vec[j],3))/(double)(nt-NTCHECK);
                        Prvec_offcen_vec[nf][iy][j]           = (double)Prvec_offcen_sum_vec[nf][iy][j]/(4/3*PI*pow((double)Prvec_rad_vec[j],3))/(double)(nt-NTCHECK);
                        Prvec_offcen_op_vec[nf][iy][j]           = (double)Prvec_offcen_op_sum_vec[nf][iy][j]/(4/3*PI*pow((double)Prvec_rad_vec[j],3))/(double)(nt-NTCHECK);
                        Prvec0_up_op_vec[nf][iy][j]           = (double)Prvec0_up_op_sum_vec[nf][iy][j]/(4/3*PI*pow((double)Prvec_rad_vec[j],3))/(double)(nt-NTCHECK);
                        Prvec_cen_up_vec[nf][iy][j]           = (double)Prvec_cen_up_sum_vec[nf][iy][j]/(4/3*PI*pow((double)Prvec_rad_vec[j],3))/(double)(nt-NTCHECK);
                        Prvec_offcen_up_vec[nf][iy][j]           = (double)Prvec_offcen_up_sum_vec[nf][iy][j]/(4/3*PI*pow((double)Prvec_rad_vec[j],3))/(double)(nt-NTCHECK);
                        Prvec_offcen_up_op_vec[nf][iy][j]           = (double)Prvec_offcen_up_op_sum_vec[nf][iy][j]/(4/3*PI*pow((double)Prvec_rad_vec[j],3))/(double)(nt-NTCHECK);

                        Prvec0_halfup_op_vec[nf][iy][j]           = (double)Prvec0_halfup_op_sum_vec[nf][iy][j]/(4/3*PI*pow((double)Prvec_rad_vec[j],3))/(double)(nt-NTCHECK);
                        Prvec_cen_halfup_vec[nf][iy][j]           = (double)Prvec_cen_halfup_sum_vec[nf][iy][j]/(4/3*PI*pow((double)Prvec_rad_vec[j],3))/(double)(nt-NTCHECK);
                        Prvec_offcen_halfup_vec[nf][iy][j]           = (double)Prvec_offcen_halfup_sum_vec[nf][iy][j]/(4/3*PI*pow((double)Prvec_rad_vec[j],3))/(double)(nt-NTCHECK);
                        Prvec_offcen_halfup_op_vec[nf][iy][j]           = (double)Prvec_offcen_halfup_op_sum_vec[nf][iy][j]/(4/3*PI*pow((double)Prvec_rad_vec[j],3))/(double)(nt-NTCHECK);
                    }
            }
        }

        POccludeBase[nf] = (double)POccludeBase_sum[nf]/(double)(nt-NTCHECK);

        // debugging
        if(0)
        {
            printf("This is the base occlusion for base %ld: %f\n",nf,POccludeBase[nf]);
            fflush(stdout);
        }

    //    for(ib=0;ib<bSiteTotal[nf];ib++)
    //    {
    //        PDeliver[nf][ib] = (double)PDeliver_sum[nf][ib]/(double)(nt-NTCHECK);
    //    }

        rMBar[nf] = rMBar_sum[nf]/(double)(nt-NTCHECK);
        rM2Bar[nf] = rM2Bar_sum[nf]/(double)(nt-NTCHECK);

        //average distance of iSites to membrane
        for (iy=0;iy<iSiteTotal[nf];iy++)
        {
            reeiSiteBar[nf][iy] = reeiSiteBar_sum[nf][iy]/(double)(nt-NTCHECK);
            ree2iSiteBar[nf][iy] = ree2iSiteBar_sum[nf][iy]/(double)(nt-NTCHECK);

            rMiSiteBar[nf][iy] = rMiSiteBar_sum[nf][iy]/(double)(nt-NTCHECK);
            rM2iSiteBar[nf][iy] = rM2iSiteBar_sum[nf][iy]/(double)(nt-NTCHECK);

        }
    }

    for(i=0;i<=NumberiSites;i++)
    {
        POcclude_NumSites[i]        = (double)POcclude_NumSites_sum[i]/(double)(nt-NTCHECK);
    }

    for(i=0;i<=NumberiSites;i++)
    {
        PAvailable_NumSites[i]        = (double)POcclude_NumSites[(int)(NumberiSites-i)];
    }


    if(MULTIPLE)
    {
        for(nf=0;nf<NFil;nf++)
        {
            // determine local concentration
            for(iy=0;iy<iSiteTotal[nf];iy++)
            {
                for(ib=0;ib<bSiteTotal[nf];ib++)
                {
                    selfBindFraction[nf][iy][ib] = (double)selfBind[nf][iy][ib]/(double)(nt-NTCHECK);
                    localConcentration[nf][iy][ib] =  selfBindFraction[nf][iy][ib] / ((double) 4/3*pow(localConcCutoff,3)*PI);
                }
            }
        }
    }

    if (!verboseTF)
    {
        if (reallyFinal == 1)
            fList = fopen(listName, "a");
        else
            fList = fopen(liveListName, "a");

        //fprintf(fList, "%ld %ld %f %f %f %f %f %f",
        fprintf(fList, "nt %ld\n", nt);         
        fprintf(fList, "NFil %ld\n", NFil);       
        fprintf(fList, "irLigand %f\n", irLigand);    
        fprintf(fList, "brLigand %f\n", brLigand);   
        fprintf(fList, "Force %f\n", Force);
        fprintf(fList, "kdimer %f\n", kdimer);  
        fprintf(fList, "dimerDist0 %f\n" ,dimerDist0); 
        fprintf(fList, "baseSepDistance %f\n" ,baseSepDistance);

        for(i=0;i<=NumberiSites;i++)
        {
            fprintf(fList, "POcclude_NumSites[i] %ld %lf\n", i, POcclude_NumSites[i]); 
        }
        for(i=0;i<=NumberiSites;i++)
        {
            fprintf(fList, "PAvailable_NumSites[i] %ld %lf\n", i, PAvailable_NumSites[i]); 
        }

        for(nf=0;nf<NFil;nf++)
        {

            //fprintf(fList, " %ld %f %f %f %f %f",
            fprintf(fList, "N[nf] %ld %ld\n", nf, N[nf]);              
            fprintf(fList, "ksStatistic[nf] %ld %f\n", nf, ksStatistic[nf]);
            fprintf(fList, "reeBar[nf] %ld %f\n", nf, reeBar[nf]);
            fprintf(fList, "ree2Bar[nf] %ld %f\n", nf, ree2Bar[nf]);
            fprintf(fList, "rMBar[nf] %ld %f\n", nf, rMBar[nf]);
            fprintf(fList, "rM2Bar[nf] %ld %f\n", nf, rM2Bar[nf]);

            for (iy=0;iy<iSiteTotal[nf];iy++)
            {
                //fprintf(fList, " %ld %e %e %e %e %f %f",
                fprintf(fList, "iSite[nf][iy] %ld %ld %ld\n",nf,iy,iSite[nf][iy]);                   
                fprintf(fList, "POcclude[nf][iy] %ld %ld %e\n",nf,iy, POcclude[nf][iy]);                
                fprintf(fList, "1-POcclude[nf][iy] %ld %ld %e\n",nf,iy,1-POcclude[nf][iy]);              
                fprintf(fList, "PMembraneOcclude[nf][iy] %ld %ld %e\n",nf,iy, PMembraneOcclude[nf][iy]); 

                fprintf(fList, "Prvec0[nf][iy] %ld %ld %e\n",nf,iy, Prvec0[nf][iy]);   
                fprintf(fList, "Prvec0_up[nf][iy] %ld %ld %e\n",nf,iy, Prvec0_up[nf][iy]);        
                fprintf(fList, "Prvec0_halfup[nf][iy] %ld %ld %e\n",nf,iy, Prvec0_halfup[nf][iy]);

                if(MULTIPLE)
                {
                    fprintf(fList, "Prvec0_bound_center[nf][iy] %ld %ld %e\n",nf,iy, Prvec0_bound[nf][iy][0]);   
                    fprintf(fList, "Prvec0_up_bound_center[nf][iy] %ld %ld %e\n",nf,iy, Prvec0_up_bound[nf][iy][0]);        
                    fprintf(fList, "Prvec0_halfup_bound_center[nf][iy] %ld %ld %e\n",nf,iy, Prvec0_halfup_bound[nf][iy][0]);

                    fprintf(fList, "Prvec0_bound_edge[nf][iy] %ld %ld %e\n",nf,iy, Prvec0_bound[nf][iy][1]);   
                    fprintf(fList, "Prvec0_up_bound_edge[nf][iy] %ld %ld %e\n",nf,iy, Prvec0_up_bound[nf][iy][1]);        
                    fprintf(fList, "Prvec0_halfup_bound_edge[nf][iy] %ld %ld %e\n",nf,iy, Prvec0_halfup_bound[nf][iy][1]);
                }

                fprintf(fList, "Prvec0_rad[nf][iy] %ld %ld %e\n",nf,iy, Prvec0_rad[nf][iy]);   
                fprintf(fList, "Prvec0_up_rad[nf][iy] %ld %ld %e\n",nf,iy, Prvec0_up_rad[nf][iy]);        
                fprintf(fList, "Prvec0_halfup_rad[nf][iy] %ld %ld %e\n",nf,iy, Prvec0_halfup_rad[nf][iy]);

                fprintf(fList, "Prvec0_sum[nf][iy] %ld %ld %lu\n",nf,iy, Prvec0_sum[nf][iy]);   
                fprintf(fList, "Prvec0_up_sum[nf][iy] %ld %ld %lu\n",nf,iy, Prvec0_up_sum[nf][iy]);        
                fprintf(fList, "Prvec0_halfup_sum[nf][iy] %ld %ld %lu\n",nf,iy, Prvec0_halfup_sum[nf][iy]);      
       
                if(NFil<=2){
                    fprintf(fList, "Prvec0_op[nf][iy] %ld %ld %e\n",nf,iy, Prvec0_op[nf][iy]);
                    fprintf(fList, "Prvec_cen[nf][iy] %ld %ld %e\n",nf,iy, Prvec_cen[nf][iy]);
                    fprintf(fList, "Prvec_offcen[nf][iy] %ld %ld %e\n",nf,iy, Prvec_offcen[nf][iy]);
                    fprintf(fList, "Prvec_offcen_op[nf][iy] %ld %ld %e\n",nf,iy, Prvec_offcen_op[nf][iy]);

                    fprintf(fList, "Prvec0_up_op[nf][iy] %ld %ld %e\n",nf,iy, Prvec0_up_op[nf][iy]);
                    fprintf(fList, "Prvec_cen_up[nf][iy] %ld %ld %e\n",nf,iy, Prvec_cen_up[nf][iy]);
                    fprintf(fList, "Prvec_offcen_up[nf][iy] %ld %ld %e\n",nf,iy, Prvec_offcen_up[nf][iy]);
                    fprintf(fList, "Prvec_offcen_up_op[nf][iy] %ld %ld %e\n",nf,iy, Prvec_offcen_up_op[nf][iy]);

                    fprintf(fList, "Prvec0_halfup_op[nf][iy] %ld %ld %e\n",nf,iy, Prvec0_halfup_op[nf][iy]);
                    fprintf(fList, "Prvec_cen_halfup[nf][iy] %ld %ld %e\n",nf,iy, Prvec_cen_halfup[nf][iy]);
                    fprintf(fList, "Prvec_offcen_halfup[nf][iy] %ld %ld %e\n",nf,iy, Prvec_offcen_halfup[nf][iy]);
                    fprintf(fList, "Prvec_offcen_halfup_op[nf][iy] %ld %ld %e\n",nf,iy, Prvec_offcen_halfup_op[nf][iy]);

                    fprintf(fList, "Prvec0_op_rad[nf][iy] %ld %ld %e\n",nf,iy, Prvec0_op_rad[nf][iy]);
                    fprintf(fList, "Prvec_cen_rad[nf][iy] %ld %ld %e\n",nf,iy, Prvec_cen_rad[nf][iy]);
                    fprintf(fList, "Prvec_offcen_rad[nf][iy] %ld %ld %e\n",nf,iy, Prvec_offcen_rad[nf][iy]);
                    fprintf(fList, "Prvec_offcen_op_rad[nf][iy] %ld %ld %e\n",nf,iy, Prvec_offcen_op_rad[nf][iy]);

                    fprintf(fList, "Prvec0_up_op_rad[nf][iy] %ld %ld %e\n",nf,iy, Prvec0_up_op_rad[nf][iy]);
                    fprintf(fList, "Prvec_cen_up_rad[nf][iy] %ld %ld %e\n",nf,iy, Prvec_cen_up_rad[nf][iy]);
                    fprintf(fList, "Prvec_offcen_up_rad[nf][iy] %ld %ld %e\n",nf,iy, Prvec_offcen_up_rad[nf][iy]);
                    fprintf(fList, "Prvec_offcen_up_op_rad[nf][iy] %ld %ld %e\n",nf,iy, Prvec_offcen_up_op_rad[nf][iy]);

                    fprintf(fList, "Prvec0_halfup_op_rad[nf][iy] %ld %ld %e\n",nf,iy, Prvec0_halfup_op_rad[nf][iy]);
                    fprintf(fList, "Prvec_cen_halfup_rad[nf][iy] %ld %ld %e\n",nf,iy, Prvec_cen_halfup_rad[nf][iy]);
                    fprintf(fList, "Prvec_offcen_halfup_rad[nf][iy] %ld %ld %e\n",nf,iy, Prvec_offcen_halfup_rad[nf][iy]);
                    fprintf(fList, "Prvec_offcen_halfup_op_rad[nf][iy] %ld %ld %e\n",nf,iy, Prvec_offcen_halfup_op_rad[nf][iy]);

                    fprintf(fList, "Prvec0_op_sum[nf][iy] %ld %ld %lu\n",nf,iy, Prvec0_op_sum[nf][iy]);
                    fprintf(fList, "Prvec_cen_sum[nf][iy] %ld %ld %lu\n",nf,iy, Prvec_cen_sum[nf][iy]);
                    fprintf(fList, "Prvec_offcen_sum[nf][iy] %ld %ld %lu\n",nf,iy, Prvec_offcen_sum[nf][iy]);
                    fprintf(fList, "Prvec_offcen_op_sum[nf][iy] %ld %ld %lu\n",nf,iy, Prvec_offcen_op_sum[nf][iy]);

                    fprintf(fList, "Prvec0_up_op_sum[nf][iy] %ld %ld %lu\n",nf,iy, Prvec0_up_op_sum[nf][iy]);
                    fprintf(fList, "Prvec_cen_up_sum[nf][iy] %ld %ld %lu\n",nf,iy, Prvec_cen_up_sum[nf][iy]);
                    fprintf(fList, "Prvec_offcen_up_sum[nf][iy] %ld %ld %lu\n",nf,iy, Prvec_offcen_up_sum[nf][iy]);
                    fprintf(fList, "Prvec_offcen_up_op_sum[nf][iy] %ld %ld %lu\n",nf,iy, Prvec_offcen_up_op_sum[nf][iy]);

                    fprintf(fList, "Prvec0_halfup_op_sum[nf][iy] %ld %ld %lu\n",nf,iy, Prvec0_halfup_op_sum[nf][iy]);
                    fprintf(fList, "Prvec_cen_halfup_sum[nf][iy] %ld %ld %lu\n",nf,iy, Prvec_cen_halfup_sum[nf][iy]);
                    fprintf(fList, "Prvec_offcen_halfup_sum[nf][iy] %ld %ld %lu\n",nf,iy, Prvec_offcen_halfup_sum[nf][iy]);
                    fprintf(fList, "Prvec_offcen_halfup_op_sum[nf][iy] %ld %ld %lu\n",nf,iy, Prvec_offcen_halfup_op_sum[nf][iy]);


                    if(MULTIPLE)
                    {
                        fprintf(fList, "Prvec0_op_bound_center[nf][iy] %ld %ld %e\n",nf,iy, Prvec0_op_bound[nf][iy][0]);
                        fprintf(fList, "Prvec_cen_bound_center[nf][iy] %ld %ld %e\n",nf,iy, Prvec_cen_bound[nf][iy][0]);
                        fprintf(fList, "Prvec_offcen_bound_center[nf][iy] %ld %ld %e\n",nf,iy, Prvec_offcen_bound[nf][iy][0]);
                        fprintf(fList, "Prvec_offcen_op_bound_center[nf][iy] %ld %ld %e\n",nf,iy, Prvec_offcen_op_bound[nf][iy][0]);

                        fprintf(fList, "Prvec0_up_op_bound_center[nf][iy] %ld %ld %e\n",nf,iy, Prvec0_up_op_bound[nf][iy][0]);
                        fprintf(fList, "Prvec_cen_up_bound_center[nf][iy] %ld %ld %e\n",nf,iy, Prvec_cen_up_bound[nf][iy][0]);
                        fprintf(fList, "Prvec_offcen_up_bound_center[nf][iy] %ld %ld %e\n",nf,iy, Prvec_offcen_up_bound[nf][iy][0]);
                        fprintf(fList, "Prvec_offcen_up_op_bound_center[nf][iy] %ld %ld %e\n",nf,iy, Prvec_offcen_up_op_bound[nf][iy][0]);

                        fprintf(fList, "Prvec0_halfup_op_bound_center[nf][iy] %ld %ld %e\n",nf,iy, Prvec0_halfup_op_bound[nf][iy][0]);
                        fprintf(fList, "Prvec_cen_halfup_bound_center[nf][iy] %ld %ld %e\n",nf,iy, Prvec_cen_halfup_bound[nf][iy][0]);
                        fprintf(fList, "Prvec_offcen_halfup_bound_center[nf][iy] %ld %ld %e\n",nf,iy, Prvec_offcen_halfup_bound[nf][iy][0]);
                        fprintf(fList, "Prvec_offcen_halfup_op_bound_center[nf][iy] %ld %ld %e\n",nf,iy, Prvec_offcen_halfup_op_bound[nf][iy][0]);

                        fprintf(fList, "Prvec0_op_bound_edge[nf][iy] %ld %ld %e\n",nf,iy, Prvec0_op_bound[nf][iy][1]);
                        fprintf(fList, "Prvec_cen_bound_edge[nf][iy] %ld %ld %e\n",nf,iy, Prvec_cen_bound[nf][iy][1]);
                        fprintf(fList, "Prvec_offcen_bound_edge[nf][iy] %ld %ld %e\n",nf,iy, Prvec_offcen_bound[nf][iy][1]);
                        fprintf(fList, "Prvec_offcen_op_bound_edge[nf][iy] %ld %ld %e\n",nf,iy, Prvec_offcen_op_bound[nf][iy][1]);

                        fprintf(fList, "Prvec0_up_op_bound_edge[nf][iy] %ld %ld %e\n",nf,iy, Prvec0_up_op_bound[nf][iy][1]);
                        fprintf(fList, "Prvec_cen_up_bound_edge[nf][iy] %ld %ld %e\n",nf,iy, Prvec_cen_up_bound[nf][iy][1]);
                        fprintf(fList, "Prvec_offcen_up_bound_edge[nf][iy] %ld %ld %e\n",nf,iy, Prvec_offcen_up_bound[nf][iy][1]);
                        fprintf(fList, "Prvec_offcen_up_op_bound_edge[nf][iy] %ld %ld %e\n",nf,iy, Prvec_offcen_up_op_bound[nf][iy][1]);

                        fprintf(fList, "Prvec0_halfup_op_bound_edge[nf][iy] %ld %ld %e\n",nf,iy, Prvec0_halfup_op_bound[nf][iy][1]);
                        fprintf(fList, "Prvec_cen_halfup_bound_edge[nf][iy] %ld %ld %e\n",nf,iy, Prvec_cen_halfup_bound[nf][iy][1]);
                        fprintf(fList, "Prvec_offcen_halfup_bound_edge[nf][iy] %ld %ld %e\n",nf,iy, Prvec_offcen_halfup_bound[nf][iy][1]);
                        fprintf(fList, "Prvec_offcen_halfup_op_bound_edge[nf][iy] %ld %ld %e\n",nf,iy, Prvec_offcen_halfup_op_bound[nf][iy][1]);
                    }
                }

                for (j=0;j<Prvec_rad_vec_size;j++)
                {
                    fprintf(fList, "Prvec0_%f[nf][iy] %ld %ld %e\n",Prvec_rad_vec[j] ,nf,iy, Prvec0_vec[nf][iy][j]);   
                    fprintf(fList, "Prvec0_up_%f[nf][iy] %ld %ld %e\n",Prvec_rad_vec[j] ,nf,iy, Prvec0_up_vec[nf][iy][j]);        
                    fprintf(fList, "Prvec0_halfup_%f[nf][iy] %ld %ld %e\n",Prvec_rad_vec[j] ,nf,iy, Prvec0_halfup_vec[nf][iy][j]);

                    fprintf(fList, "Prvec0_sum_%f[nf][iy] %ld %ld %lu\n",Prvec_rad_vec[j] ,nf,iy, Prvec0_sum_vec[nf][iy][j]);   
                    fprintf(fList, "Prvec0_up_sum_%f[nf][iy] %ld %ld %lu\n",Prvec_rad_vec[j] ,nf,iy, Prvec0_up_sum_vec[nf][iy][j]);        
                    fprintf(fList, "Prvec0_halfup_sum_%f[nf][iy] %ld %ld %lu\n",Prvec_rad_vec[j] ,nf,iy, Prvec0_halfup_sum_vec[nf][iy][j]);      
        
                    if(NFil<=2){
                        fprintf(fList, "Prvec0_op_%f[nf][iy] %ld %ld %e\n",Prvec_rad_vec[j] ,nf,iy, Prvec0_op_vec[nf][iy][j]);
                        fprintf(fList, "Prvec_cen_%f[nf][iy] %ld %ld %e\n",Prvec_rad_vec[j] ,nf,iy, Prvec_cen_vec[nf][iy][j]);
                        fprintf(fList, "Prvec_offcen_%f[nf][iy] %ld %ld %e\n",Prvec_rad_vec[j] ,nf,iy, Prvec_offcen_vec[nf][iy][j]);
                        fprintf(fList, "Prvec_offcen_op_%f[nf][iy] %ld %ld %e\n",Prvec_rad_vec[j] ,nf,iy, Prvec_offcen_op_vec[nf][iy][j]);

                        fprintf(fList, "Prvec0_up_op_%f[nf][iy] %ld %ld %e\n",Prvec_rad_vec[j] ,nf,iy, Prvec0_up_op_vec[nf][iy][j]);
                        fprintf(fList, "Prvec_cen_up_%f[nf][iy] %ld %ld %e\n",Prvec_rad_vec[j] ,nf,iy, Prvec_cen_up_vec[nf][iy][j]);
                        fprintf(fList, "Prvec_offcen_up_%f[nf][iy] %ld %ld %e\n",Prvec_rad_vec[j] ,nf,iy, Prvec_offcen_up_vec[nf][iy][j]);
                        fprintf(fList, "Prvec_offcen_up_op_%f[nf][iy] %ld %ld %e\n",Prvec_rad_vec[j] ,nf,iy, Prvec_offcen_up_op_vec[nf][iy][j]);

                        fprintf(fList, "Prvec0_halfup_op_%f[nf][iy] %ld %ld %e\n",Prvec_rad_vec[j] ,nf,iy, Prvec0_halfup_op_vec[nf][iy][j]);
                        fprintf(fList, "Prvec_cen_halfup_%f[nf][iy] %ld %ld %e\n",Prvec_rad_vec[j] ,nf,iy, Prvec_cen_halfup_vec[nf][iy][j]);
                        fprintf(fList, "Prvec_offcen_halfup_%f[nf][iy] %ld %ld %e\n",Prvec_rad_vec[j] ,nf,iy, Prvec_offcen_halfup_vec[nf][iy][j]);
                        fprintf(fList, "Prvec_offcen_halfup_op_%f[nf][iy] %ld %ld %e\n",Prvec_rad_vec[j] ,nf,iy, Prvec_offcen_halfup_op_vec[nf][iy][j]);

                        fprintf(fList, "Prvec0_op_sum_%f[nf][iy] %ld %ld %lu\n",Prvec_rad_vec[j] ,nf,iy, Prvec0_op_sum_vec[nf][iy][j]);
                        fprintf(fList, "Prvec_cen_sum_%f[nf][iy] %ld %ld %lu\n",Prvec_rad_vec[j] ,nf,iy, Prvec_cen_sum_vec[nf][iy][j]);
                        fprintf(fList, "Prvec_offcen_sum_%f[nf][iy] %ld %ld %lu\n",Prvec_rad_vec[j] ,nf,iy, Prvec_offcen_sum_vec[nf][iy][j]);
                        fprintf(fList, "Prvec_offcen_op_sum_%f[nf][iy] %ld %ld %lu\n",Prvec_rad_vec[j] ,nf,iy, Prvec_offcen_op_sum_vec[nf][iy][j]);

                        fprintf(fList, "Prvec0_up_op_sum_%f[nf][iy] %ld %ld %lu\n",Prvec_rad_vec[j] ,nf,iy, Prvec0_up_op_sum_vec[nf][iy][j]);
                        fprintf(fList, "Prvec_cen_up_sum_%f[nf][iy] %ld %ld %lu\n",Prvec_rad_vec[j] ,nf,iy, Prvec_cen_up_sum_vec[nf][iy][j]);
                        fprintf(fList, "Prvec_offcen_up_sum_%f[nf][iy] %ld %ld %lu\n",Prvec_rad_vec[j] ,nf,iy, Prvec_offcen_up_sum_vec[nf][iy][j]);
                        fprintf(fList, "Prvec_offcen_up_op_sum_%f[nf][iy] %ld %ld %lu\n",Prvec_rad_vec[j] ,nf,iy, Prvec_offcen_up_op_sum_vec[nf][iy][j]);

                        fprintf(fList, "Prvec0_halfup_op_sum_%f[nf][iy] %ld %ld %lu\n",Prvec_rad_vec[j] ,nf,iy, Prvec0_halfup_op_sum_vec[nf][iy][j]);
                        fprintf(fList, "Prvec_cen_halfup_sum_%f[nf][iy] %ld %ld %lu\n",Prvec_rad_vec[j] ,nf,iy, Prvec_cen_halfup_sum_vec[nf][iy][j]);
                        fprintf(fList, "Prvec_offcen_halfup_sum_%f[nf][iy] %ld %ld %lu\n",Prvec_rad_vec[j] ,nf,iy, Prvec_offcen_halfup_sum_vec[nf][iy][j]);
                        fprintf(fList, "Prvec_offcen_halfup_op_sum_%f[nf][iy] %ld %ld %lu\n",Prvec_rad_vec[j] ,nf,iy, Prvec_offcen_halfup_op_sum_vec[nf][iy][j]);
                    }
                }

                fprintf(fList, "rMiSiteBar[nf][iy] %ld %ld %lf\n",nf,iy,rMiSiteBar[nf][iy]);              
                fprintf(fList, "rM2iSiteBar[nf][iy] %ld %ld %lf\n",nf,iy,rM2iSiteBar[nf][iy]);     
            }


            fprintf(fList, "1-POccludeBase[nf] %ld %e\n", nf, 1-POccludeBase[nf]);        

            for(nf2=0;nf2<NFil;nf2++)
            {
                fprintf(fList, "reeFilBar[nf][nf2] %ld %ld %f\n", nf, nf2, reeFilBar[nf][nf2]);        
            }

            for(nf2=0;nf2<NFil;nf2++)
            {
                fprintf(fList, "ree2FilBar[nf][nf2] %ld %ld %f\n", nf, nf2, ree2FilBar[nf][nf2]);   
            }

            for (iy=0;iy<iSiteTotal[nf];iy++)
            {
                fprintf(fList, "reeiSiteBar[nf][iy] %ld %ld %lf\n", nf, iy, reeiSiteBar[nf][iy]);         
                fprintf(fList, "ree2iSiteBar[nf][iy] %ld %ld %lf\n", nf, iy, ree2iSiteBar[nf][iy]);     
            }

            // print distribution of iSite Locations
            if(0)
            {
                for (iy=0;iy<iSiteTotal[nf];iy++)
                {
                    iSiteCurrent=iSite[nf][iy];
                    for (j=0;j<NBINSPOLYMER;j++)
                    {
                        fprintf(fList, "polymerLocationCounts[nf][iSiteCurrent][j] %ld %ld %ld %ld\n", 
                            nf, iSiteCurrent, j, polymerLocationCounts[nf][iSiteCurrent][j]);
                    }
                }
            }

            // print distributions of end segments locations
            if(0)
            {
                for (j=0;j<NBINSPOLYMER;j++)
                {
                    Ncurrent = N[nf];
                    fprintf(fList, "polymerLocationCounts[nf][Ncurrent-1][j] %ld %ld %ld %ld\n", 
                        nf, Ncurrent-1, j, polymerLocationCounts[nf][Ncurrent-1][j]);
                }
            }

        } // end printing data for each filament

        if (CD3ZETA)
        {
            for (i=0; i<NumberiSites;i++)
            {
                fprintf(fList, "occupied[i] %ld %lf", i, occupied[i]);
            }

            fprintf(fList, "occupiedSitesNoSpace %s\n", occupiedSitesNoSpace);
        }

        //fprintf(fList, "\n");
        fclose(fList);
    }
    if(verboseTF && VISUALIZE)
    {
        //print second file with only parameters for the run
        char listNameParams[200];
        strcpy(listNameParams,listName);
        strcat(listNameParams,"_VisualParameters");

        fList = fopen(listNameParams,"a");

        // formulas only work for identical filaments
        fprintf(fList, "%d %d %d %ld %f %f",
                MEMBRANE,   // 1
                MULTIPLE,   // 2
                BASEBOUND,  // 3
                NFil,       // 4
                irLigand,   // 5
                brLigand);     // 6

        for(nf=0;nf<NFil;nf++)
        {

            fprintf(fList, " %ld %ld %ld %ld",
                    nf,                 // 8 +
                    N[nf],              // 9 +
                    iSiteTotal[nf],     // 10 +
                    bSiteTotal[nf]);   // 11 +

            for (iy=0;iy<iSiteTotal[nf];iy++)
            {
                fprintf(fList, " %ld",
                        iSite[nf][iy]);             // 13 + iBind + (6 + 7*iSiteTotal + 2 + NFil + NFil)*nf
            }
            if(MULTIPLE)
            {
                for (ib=0;ib<bSiteTotal[nf];ib++)
                {
                    fprintf(fList, " %ld",
                            bSite[nf][ib]);             // 14 + iSiteTotal[nf]-1 + bBind + (6 + 7*iSiteTotal + 2 + NFil + NFil)*nf
                }
            }

        } // end printing data for each filament
        if(BASEBOUND)
        {
            fprintf(fList, " %f",
                    baserLigand);        // 1
        }

        fprintf(fList, "\n");
        fclose(fList);

    }
}

/********************************************************************************************************/
// Prepare stuff and optionally write to file - this function is called each timestep
void dataRecording()
{

    // end-to-end distance
    for(nf=0;nf<NFil;nf++)
    {
        Ncurrent = N[nf];
        ree[nf]  = sqrt((r[nf][Ncurrent-1][0]-rBase[nf][0])*(r[nf][Ncurrent-1][0]-rBase[nf][0])+
                        (r[nf][Ncurrent-1][1]-rBase[nf][1])*(r[nf][Ncurrent-1][1]-rBase[nf][1])+
                        (r[nf][Ncurrent-1][2]-rBase[nf][2])*(r[nf][Ncurrent-1][2]-rBase[nf][2]));
    }

    // distance between ends of filaments
    for(nf=0;nf<NFil;nf++)
    {
        for(nf2=0;nf2<NFil;nf2++)
        {
            Ncurrent = N[nf];
            reeFil[nf][nf2] = sqrt((r[nf][Ncurrent-1][0]-r[nf2][Ncurrent-1][0])*(r[nf][Ncurrent-1][0]-r[nf2][Ncurrent-1][0])+
                                  (r[nf][Ncurrent-1][1]-r[nf2][Ncurrent-1][1])*(r[nf][Ncurrent-1][1]-r[nf2][Ncurrent-1][1])+
                                  (r[nf][Ncurrent-1][2]-r[nf2][Ncurrent-1][2])*(r[nf][Ncurrent-1][2]-r[nf2][Ncurrent-1][2]));
        }
    }

    // distance from base to iSite
    for(nf=0;nf<NFil;nf++)
    {
        double yshift= 16.6667;
        double halfyshift= 8.33335;
        ib=0;
        for(iy=0;iy<iSiteTotal[nf];iy++)
        {
            iSiteCurrent = iSite[nf][iy];
            reeiSite[nf][iy] = sqrt((r[nf][iSiteCurrent][0]-rBase[nf][0])*(r[nf][iSiteCurrent][0]-rBase[nf][0]) +
                                    (r[nf][iSiteCurrent][1]-rBase[nf][1])*(r[nf][iSiteCurrent][1]-rBase[nf][1]) +
                                    (r[nf][iSiteCurrent][2]-rBase[nf][2])*(r[nf][iSiteCurrent][2]-rBase[nf][2]));
            reeiSite_up[nf][iy] = sqrt((r[nf][iSiteCurrent][0]-rBase[nf][0])*(r[nf][iSiteCurrent][0]-rBase[nf][0]) +
                                    (r[nf][iSiteCurrent][1]-rBase[nf][1])*(r[nf][iSiteCurrent][1]-rBase[nf][1]) +
                                    (r[nf][iSiteCurrent][2]-(rBase[nf][2]+yshift))*(r[nf][iSiteCurrent][2]-(rBase[nf][2]+yshift)));
            reeiSite_halfup[nf][iy] = sqrt((r[nf][iSiteCurrent][0]-rBase[nf][0])*(r[nf][iSiteCurrent][0]-rBase[nf][0]) +
                                    (r[nf][iSiteCurrent][1]-rBase[nf][1])*(r[nf][iSiteCurrent][1]-rBase[nf][1]) +
                                    (r[nf][iSiteCurrent][2]-(rBase[nf][2]+halfyshift))*(r[nf][iSiteCurrent][2]-(rBase[nf][2]+halfyshift)));
            
        
            if(NFil<=2){
                double rBase_op;
                double rBase_cen = (rBase[0][0] + (0.5 * baseSepDistance));
                double rBase_offcen;
                double rBase_offcen_op;
                if(nf==0)
                {
                    rBase_op = rBase[0][0] + baseSepDistance;
                    rBase_offcen = rBase_cen - (8.33333333333333);
                    rBase_offcen_op = rBase_cen + (8.33333333333333);
                }
                else if(nf==1)
                {
                    rBase_op = rBase[0][0] + 0; 
                    rBase_offcen = rBase_cen + (8.33333333333333);
                    rBase_offcen_op = rBase_cen - (8.33333333333333);
                }
                
                reeiSite_op[nf][iy] = sqrt((r[nf][iSiteCurrent][0]-rBase_op)*(r[nf][iSiteCurrent][0]-rBase_op) +
                                    (r[nf][iSiteCurrent][1]-rBase[nf][1])*(r[nf][iSiteCurrent][1]-rBase[nf][1]) +
                                    (r[nf][iSiteCurrent][2]-rBase[nf][2])*(r[nf][iSiteCurrent][2]-rBase[nf][2]));

                reeiSite_cen[nf][iy] = sqrt((r[nf][iSiteCurrent][0]-rBase_cen)*(r[nf][iSiteCurrent][0]-(rBase_cen)) +
                                    (r[nf][iSiteCurrent][1]-rBase[nf][1])*(r[nf][iSiteCurrent][1]-rBase[nf][1]) +
                                    (r[nf][iSiteCurrent][2]-rBase[nf][2])*(r[nf][iSiteCurrent][2]-rBase[nf][2]));

                reeiSite_offcen[nf][iy] = sqrt((r[nf][iSiteCurrent][0]-rBase_offcen)*(r[nf][iSiteCurrent][0]-(rBase_offcen)) +
                                    (r[nf][iSiteCurrent][1]-rBase[nf][1])*(r[nf][iSiteCurrent][1]-rBase[nf][1]) +
                                    (r[nf][iSiteCurrent][2]-rBase[nf][2])*(r[nf][iSiteCurrent][2]-rBase[nf][2]));
                
                reeiSite_offcen_op[nf][iy] = sqrt((r[nf][iSiteCurrent][0]-rBase_offcen_op)*(r[nf][iSiteCurrent][0]-(rBase_offcen_op)) +
                                    (r[nf][iSiteCurrent][1]-rBase[nf][1])*(r[nf][iSiteCurrent][1]-rBase[nf][1]) +
                                    (r[nf][iSiteCurrent][2]-rBase[nf][2])*(r[nf][iSiteCurrent][2]-rBase[nf][2]));

                reeiSite_up_op[nf][iy] = sqrt((r[nf][iSiteCurrent][0]-rBase_op)*(r[nf][iSiteCurrent][0]-rBase_op) +
                                    (r[nf][iSiteCurrent][1]-rBase[nf][1])*(r[nf][iSiteCurrent][1]-rBase[nf][1]) +
                                    (r[nf][iSiteCurrent][2]-(rBase[nf][2]+yshift))*(r[nf][iSiteCurrent][2]-(rBase[nf][2]+yshift)));

                reeiSite_cen_up[nf][iy] = sqrt((r[nf][iSiteCurrent][0]-rBase_cen)*(r[nf][iSiteCurrent][0]-(rBase_cen)) +
                                    (r[nf][iSiteCurrent][1]-rBase[nf][1])*(r[nf][iSiteCurrent][1]-rBase[nf][1]) +
                                    (r[nf][iSiteCurrent][2]-(rBase[nf][2]+yshift))*(r[nf][iSiteCurrent][2]-(rBase[nf][2]+yshift)));

                reeiSite_offcen_up[nf][iy] = sqrt((r[nf][iSiteCurrent][0]-rBase_offcen)*(r[nf][iSiteCurrent][0]-(rBase_offcen)) +
                                    (r[nf][iSiteCurrent][1]-rBase[nf][1])*(r[nf][iSiteCurrent][1]-rBase[nf][1]) +
                                    (r[nf][iSiteCurrent][2]-(rBase[nf][2]+yshift))*(r[nf][iSiteCurrent][2]-(rBase[nf][2]+yshift)));
                
                reeiSite_offcen_up_op[nf][iy] = sqrt((r[nf][iSiteCurrent][0]-rBase_offcen_op)*(r[nf][iSiteCurrent][0]-(rBase_offcen_op)) +
                                    (r[nf][iSiteCurrent][1]-rBase[nf][1])*(r[nf][iSiteCurrent][1]-rBase[nf][1]) +
                                    (r[nf][iSiteCurrent][2]-(rBase[nf][2]+yshift))*(r[nf][iSiteCurrent][2]-(rBase[nf][2]+yshift)));
                reeiSite_halfup_op[nf][iy] = sqrt((r[nf][iSiteCurrent][0]-rBase_op)*(r[nf][iSiteCurrent][0]-rBase_op) +
                                    (r[nf][iSiteCurrent][1]-rBase[nf][1])*(r[nf][iSiteCurrent][1]-rBase[nf][1]) +
                                    (r[nf][iSiteCurrent][2]-(rBase[nf][2]+halfyshift))*(r[nf][iSiteCurrent][2]-(rBase[nf][2]+halfyshift)));

                reeiSite_cen_halfup[nf][iy] = sqrt((r[nf][iSiteCurrent][0]-rBase_cen)*(r[nf][iSiteCurrent][0]-(rBase_cen)) +
                                    (r[nf][iSiteCurrent][1]-rBase[nf][1])*(r[nf][iSiteCurrent][1]-rBase[nf][1]) +
                                    (r[nf][iSiteCurrent][2]-(rBase[nf][2]+halfyshift))*(r[nf][iSiteCurrent][2]-(rBase[nf][2]+halfyshift)));

                reeiSite_offcen_halfup[nf][iy] = sqrt((r[nf][iSiteCurrent][0]-rBase_offcen)*(r[nf][iSiteCurrent][0]-(rBase_offcen)) +
                                    (r[nf][iSiteCurrent][1]-rBase[nf][1])*(r[nf][iSiteCurrent][1]-rBase[nf][1]) +
                                    (r[nf][iSiteCurrent][2]-(rBase[nf][2]+halfyshift))*(r[nf][iSiteCurrent][2]-(rBase[nf][2]+halfyshift)));
                
                reeiSite_offcen_halfup_op[nf][iy] = sqrt((r[nf][iSiteCurrent][0]-rBase_offcen_op)*(r[nf][iSiteCurrent][0]-(rBase_offcen_op)) +
                                    (r[nf][iSiteCurrent][1]-rBase[nf][1])*(r[nf][iSiteCurrent][1]-rBase[nf][1]) +
                                    (r[nf][iSiteCurrent][2]-(rBase[nf][2]+halfyshift))*(r[nf][iSiteCurrent][2]-(rBase[nf][2]+halfyshift)));
            }

            if(iy==bSite[nf][ib])
            {
                double bLigandEdge[3];
                bLigandEdge[0]=bLigandCenter[nf][ib][0]+(bLigandCenter[nf][ib][0]-r[nf][iSiteCurrent][0]);
                bLigandEdge[1]=bLigandCenter[nf][ib][1]+(bLigandCenter[nf][ib][1]-r[nf][iSiteCurrent][1]);
                bLigandEdge[2]=bLigandCenter[nf][ib][2]+(bLigandCenter[nf][ib][2]-r[nf][iSiteCurrent][2]);

                reeiSite_bound[nf][iy][0] = sqrt((bLigandCenter[nf][ib][0]-rBase[nf][0])*(bLigandCenter[nf][ib][0]-rBase[nf][0]) +
                                    (bLigandCenter[nf][ib][1]-rBase[nf][1])*(bLigandCenter[nf][ib][1]-rBase[nf][1]) +
                                    (bLigandCenter[nf][ib][2]-rBase[nf][2])*(bLigandCenter[nf][ib][2]-rBase[nf][2]));
                reeiSite_bound[nf][iy][1] = sqrt((bLigandEdge[0]-rBase[nf][0])*(bLigandEdge[0]-rBase[nf][0]) +
                                    (bLigandEdge[1]-rBase[nf][1])*(bLigandEdge[1]-rBase[nf][1]) +
                                    (bLigandEdge[2]-rBase[nf][2])*(bLigandEdge[2]-rBase[nf][2]));

                reeiSite_up_bound[nf][iy][0] = sqrt((bLigandCenter[nf][ib][0]-rBase[nf][0])*(bLigandCenter[nf][ib][0]-rBase[nf][0]) +
                                    (bLigandCenter[nf][ib][1]-rBase[nf][1])*(bLigandCenter[nf][ib][1]-rBase[nf][1]) +
                                    (bLigandCenter[nf][ib][2]-(rBase[nf][2]+yshift))*(bLigandCenter[nf][ib][2]-(rBase[nf][2]+yshift)));
                reeiSite_halfup_bound[nf][iy][0] = sqrt((bLigandCenter[nf][ib][0]-rBase[nf][0])*(bLigandCenter[nf][ib][0]-rBase[nf][0]) +
                                    (bLigandCenter[nf][ib][1]-rBase[nf][1])*(bLigandCenter[nf][ib][1]-rBase[nf][1]) +
                                    (bLigandCenter[nf][ib][2]-(rBase[nf][2]+halfyshift))*(bLigandCenter[nf][ib][2]-(rBase[nf][2]+halfyshift))); 

                reeiSite_up_bound[nf][iy][1] = sqrt((bLigandEdge[0]-rBase[nf][0])*(bLigandEdge[0]-rBase[nf][0]) +
                                    (bLigandEdge[1]-rBase[nf][1])*(bLigandEdge[1]-rBase[nf][1]) +
                                    (bLigandEdge[2]-(rBase[nf][2]+yshift))*(bLigandEdge[2]-(rBase[nf][2]+yshift)));
                reeiSite_halfup_bound[nf][iy][1] = sqrt((bLigandEdge[0]-rBase[nf][0])*(bLigandEdge[0]-rBase[nf][0]) +
                                    (bLigandEdge[1]-rBase[nf][1])*(bLigandEdge[1]-rBase[nf][1]) +
                                    (bLigandEdge[2]-(rBase[nf][2]+halfyshift))*(bLigandEdge[2]-(rBase[nf][2]+halfyshift)));                   
                ib++;

                if(NFil<=2){
                    double rBase_op;
                    double rBase_cen = (rBase[0][0] + (0.5 * baseSepDistance));
                    double rBase_offcen;
                    double rBase_offcen_op;
                    if(nf==0)
                    {
                        rBase_op = rBase[0][0] + baseSepDistance;
                        rBase_offcen = rBase_cen - (8.33333333333333);
                        rBase_offcen_op = rBase_cen + (8.33333333333333);
                    }
                    else if(nf==1)
                    {
                        rBase_op = rBase[0][0] + 0; 
                        rBase_offcen = rBase_cen + (8.33333333333333);
                        rBase_offcen_op = rBase_cen - (8.33333333333333);
                    }
                    reeiSite_op_bound[nf][iy][0] = sqrt((bLigandCenter[nf][ib][0]-rBase_op)*(bLigandCenter[nf][ib][0]-rBase_op) +
                                        (bLigandCenter[nf][ib][1]-rBase[nf][1])*(bLigandCenter[nf][ib][1]-rBase[nf][1]) +
                                        (bLigandCenter[nf][ib][2]-rBase[nf][2])*(bLigandCenter[nf][ib][2]-rBase[nf][2]));

                    reeiSite_cen_bound[nf][iy][0] = sqrt((bLigandCenter[nf][ib][0]-rBase_cen)*(bLigandCenter[nf][ib][0]-(rBase_cen)) +
                                        (bLigandCenter[nf][ib][1]-rBase[nf][1])*(bLigandCenter[nf][ib][1]-rBase[nf][1]) +
                                        (bLigandCenter[nf][ib][2]-rBase[nf][2])*(bLigandCenter[nf][ib][2]-rBase[nf][2]));

                    reeiSite_offcen_bound[nf][iy][0] = sqrt((bLigandCenter[nf][ib][0]-rBase_offcen)*(bLigandCenter[nf][ib][0]-(rBase_offcen)) +
                                        (bLigandCenter[nf][ib][1]-rBase[nf][1])*(bLigandCenter[nf][ib][1]-rBase[nf][1]) +
                                        (bLigandCenter[nf][ib][2]-rBase[nf][2])*(bLigandCenter[nf][ib][2]-rBase[nf][2]));
                    
                    reeiSite_offcen_op_bound[nf][iy][0] = sqrt((bLigandCenter[nf][ib][0]-rBase_offcen_op)*(bLigandCenter[nf][ib][0]-(rBase_offcen_op)) +
                                        (bLigandCenter[nf][ib][1]-rBase[nf][1])*(bLigandCenter[nf][ib][1]-rBase[nf][1]) +
                                        (bLigandCenter[nf][ib][2]-rBase[nf][2])*(bLigandCenter[nf][ib][2]-rBase[nf][2]));

                    reeiSite_up_op_bound[nf][iy][0] = sqrt((bLigandCenter[nf][ib][0]-rBase_op)*(bLigandCenter[nf][ib][0]-rBase_op) +
                                        (bLigandCenter[nf][ib][1]-rBase[nf][1])*(bLigandCenter[nf][ib][1]-rBase[nf][1]) +
                                        (bLigandCenter[nf][ib][2]-(rBase[nf][2]+yshift))*(bLigandCenter[nf][ib][2]-(rBase[nf][2]+yshift)));

                    reeiSite_cen_up_bound[nf][iy][0] = sqrt((bLigandCenter[nf][ib][0]-rBase_cen)*(bLigandCenter[nf][ib][0]-(rBase_cen)) +
                                        (bLigandCenter[nf][ib][1]-rBase[nf][1])*(bLigandCenter[nf][ib][1]-rBase[nf][1]) +
                                        (bLigandCenter[nf][ib][2]-(rBase[nf][2]+yshift))*(bLigandCenter[nf][ib][2]-(rBase[nf][2]+yshift)));

                    reeiSite_offcen_up_bound[nf][iy][0] = sqrt((bLigandCenter[nf][ib][0]-rBase_offcen)*(bLigandCenter[nf][ib][0]-(rBase_offcen)) +
                                        (bLigandCenter[nf][ib][1]-rBase[nf][1])*(bLigandCenter[nf][ib][1]-rBase[nf][1]) +
                                        (bLigandCenter[nf][ib][2]-(rBase[nf][2]+yshift))*(bLigandCenter[nf][ib][2]-(rBase[nf][2]+yshift)));
                    
                    reeiSite_offcen_up_op_bound[nf][iy][0] = sqrt((bLigandCenter[nf][ib][0]-rBase_offcen_op)*(bLigandCenter[nf][ib][0]-(rBase_offcen_op)) +
                                        (bLigandCenter[nf][ib][1]-rBase[nf][1])*(bLigandCenter[nf][ib][1]-rBase[nf][1]) +
                                        (bLigandCenter[nf][ib][2]-(rBase[nf][2]+yshift))*(bLigandCenter[nf][ib][2]-(rBase[nf][2]+yshift)));
                    reeiSite_halfup_op_bound[nf][iy][0] = sqrt((bLigandCenter[nf][ib][0]-rBase_op)*(bLigandCenter[nf][ib][0]-rBase_op) +
                                        (bLigandCenter[nf][ib][1]-rBase[nf][1])*(bLigandCenter[nf][ib][1]-rBase[nf][1]) +
                                        (bLigandCenter[nf][ib][2]-(rBase[nf][2]+halfyshift))*(bLigandCenter[nf][ib][2]-(rBase[nf][2]+halfyshift)));

                    reeiSite_cen_halfup_bound[nf][iy][0] = sqrt((bLigandCenter[nf][ib][0]-rBase_cen)*(bLigandCenter[nf][ib][0]-(rBase_cen)) +
                                        (bLigandCenter[nf][ib][1]-rBase[nf][1])*(bLigandCenter[nf][ib][1]-rBase[nf][1]) +
                                        (bLigandCenter[nf][ib][2]-(rBase[nf][2]+halfyshift))*(bLigandCenter[nf][ib][2]-(rBase[nf][2]+halfyshift)));

                    reeiSite_offcen_halfup_bound[nf][iy][0] = sqrt((bLigandCenter[nf][ib][0]-rBase_offcen)*(bLigandCenter[nf][ib][0]-(rBase_offcen)) +
                                        (bLigandCenter[nf][ib][1]-rBase[nf][1])*(bLigandCenter[nf][ib][1]-rBase[nf][1]) +
                                        (bLigandCenter[nf][ib][2]-(rBase[nf][2]+halfyshift))*(bLigandCenter[nf][ib][2]-(rBase[nf][2]+halfyshift)));
                    
                    reeiSite_offcen_halfup_op_bound[nf][iy][0] = sqrt((bLigandCenter[nf][ib][0]-rBase_offcen_op)*(bLigandCenter[nf][ib][0]-(rBase_offcen_op)) +
                                        (bLigandCenter[nf][ib][1]-rBase[nf][1])*(bLigandCenter[nf][ib][1]-rBase[nf][1]) +
                                        (bLigandCenter[nf][ib][2]-(rBase[nf][2]+halfyshift))*(bLigandCenter[nf][ib][2]-(rBase[nf][2]+halfyshift)));

                    //
                    reeiSite_op_bound[nf][iy][1] = sqrt((bLigandEdge[0]-rBase_op)*(bLigandEdge[0]-rBase_op) +
                                        (bLigandEdge[1]-rBase[nf][1])*(bLigandEdge[1]-rBase[nf][1]) +
                                        (bLigandEdge[2]-rBase[nf][2])*(bLigandEdge[2]-rBase[nf][2]));

                    reeiSite_cen_bound[nf][iy][1] = sqrt((bLigandEdge[0]-rBase_cen)*(bLigandEdge[0]-(rBase_cen)) +
                                        (bLigandEdge[1]-rBase[nf][1])*(bLigandEdge[1]-rBase[nf][1]) +
                                        (bLigandEdge[2]-rBase[nf][2])*(bLigandEdge[2]-rBase[nf][2]));

                    reeiSite_offcen_bound[nf][iy][1] = sqrt((bLigandEdge[0]-rBase_offcen)*(bLigandEdge[0]-(rBase_offcen)) +
                                        (bLigandEdge[1]-rBase[nf][1])*(bLigandEdge[1]-rBase[nf][1]) +
                                        (bLigandEdge[2]-rBase[nf][2])*(bLigandEdge[2]-rBase[nf][2]));
                    
                    reeiSite_offcen_op_bound[nf][iy][1] = sqrt((bLigandEdge[0]-rBase_offcen_op)*(bLigandEdge[0]-(rBase_offcen_op)) +
                                        (bLigandEdge[1]-rBase[nf][1])*(bLigandEdge[1]-rBase[nf][1]) +
                                        (bLigandEdge[2]-rBase[nf][2])*(bLigandEdge[2]-rBase[nf][2]));

                    reeiSite_up_op_bound[nf][iy][1] = sqrt((bLigandEdge[0]-rBase_op)*(bLigandEdge[0]-rBase_op) +
                                        (bLigandEdge[1]-rBase[nf][1])*(bLigandEdge[1]-rBase[nf][1]) +
                                        (bLigandEdge[2]-(rBase[nf][2]+yshift))*(bLigandEdge[2]-(rBase[nf][2]+yshift)));

                    reeiSite_cen_up_bound[nf][iy][1] = sqrt((bLigandEdge[0]-rBase_cen)*(bLigandEdge[0]-(rBase_cen)) +
                                        (bLigandEdge[1]-rBase[nf][1])*(bLigandEdge[1]-rBase[nf][1]) +
                                        (bLigandEdge[2]-(rBase[nf][2]+yshift))*(bLigandEdge[2]-(rBase[nf][2]+yshift)));

                    reeiSite_offcen_up_bound[nf][iy][1] = sqrt((bLigandEdge[0]-rBase_offcen)*(bLigandEdge[0]-(rBase_offcen)) +
                                        (bLigandEdge[1]-rBase[nf][1])*(bLigandEdge[1]-rBase[nf][1]) +
                                        (bLigandEdge[2]-(rBase[nf][2]+yshift))*(bLigandEdge[2]-(rBase[nf][2]+yshift)));
                    
                    reeiSite_offcen_up_op_bound[nf][iy][1] = sqrt((bLigandEdge[0]-rBase_offcen_op)*(bLigandEdge[0]-(rBase_offcen_op)) +
                                        (bLigandEdge[1]-rBase[nf][1])*(bLigandEdge[1]-rBase[nf][1]) +
                                        (bLigandEdge[2]-(rBase[nf][2]+yshift))*(bLigandEdge[2]-(rBase[nf][2]+yshift)));
                    reeiSite_halfup_op_bound[nf][iy][1] = sqrt((bLigandEdge[0]-rBase_op)*(bLigandEdge[0]-rBase_op) +
                                        (bLigandEdge[1]-rBase[nf][1])*(bLigandEdge[1]-rBase[nf][1]) +
                                        (bLigandEdge[2]-(rBase[nf][2]+halfyshift))*(bLigandEdge[2]-(rBase[nf][2]+halfyshift)));

                    reeiSite_cen_halfup_bound[nf][iy][1] = sqrt((bLigandEdge[0]-rBase_cen)*(bLigandEdge[0]-(rBase_cen)) +
                                        (bLigandEdge[1]-rBase[nf][1])*(bLigandEdge[1]-rBase[nf][1]) +
                                        (bLigandEdge[2]-(rBase[nf][2]+halfyshift))*(bLigandEdge[2]-(rBase[nf][2]+halfyshift)));

                    reeiSite_offcen_halfup_bound[nf][iy][1] = sqrt((bLigandEdge[0]-rBase_offcen)*(bLigandEdge[0]-(rBase_offcen)) +
                                        (bLigandEdge[1]-rBase[nf][1])*(bLigandEdge[1]-rBase[nf][1]) +
                                        (bLigandEdge[2]-(rBase[nf][2]+halfyshift))*(bLigandEdge[2]-(rBase[nf][2]+halfyshift)));
                    
                    reeiSite_offcen_halfup_op_bound[nf][iy][1] = sqrt((bLigandEdge[0]-rBase_offcen_op)*(bLigandEdge[0]-(rBase_offcen_op)) +
                                        (bLigandEdge[1]-rBase[nf][1])*(bLigandEdge[1]-rBase[nf][1]) +
                                        (bLigandEdge[2]-(rBase[nf][2]+halfyshift))*(bLigandEdge[2]-(rBase[nf][2]+halfyshift)));
                }
            }

            ree2iSite[nf][iy] = (r[nf][iSiteCurrent][0]-rBase[nf][0])*(r[nf][iSiteCurrent][0]-rBase[nf][0]) +
                                    (r[nf][iSiteCurrent][1]-rBase[nf][1])*(r[nf][iSiteCurrent][1]-rBase[nf][1]) +
                                    (r[nf][iSiteCurrent][2]-rBase[nf][2])*(r[nf][iSiteCurrent][2]-rBase[nf][2]);
        }

    }

    // distance of tip to membrane
    for(nf=0;nf<NFil;nf++)
    {
        Ncurrent = N[nf];
        rM[nf] = r[nf][Ncurrent-1][2];
        rM2[nf] = r[nf][Ncurrent-1][2]*r[nf][Ncurrent-1][2];
    }

    //distance of iSites to membrane
    for(nf=0;nf<NFil;nf++)
    {
        for (iy=0;iy<iSiteTotal[nf];iy++)
        {
            iSiteCurrent = iSite[nf][iy];
            rMiSite[nf][iy] = r[nf][iSiteCurrent][2];
            rM2iSite[nf][iy] = r[nf][iSiteCurrent][2]*r[nf][iSiteCurrent][2];
        }
    }

    // height (max distance to membrane)
	if  (0)
    {
        for(nf=0;nf<NFil;nf++)
        {
            rH[nf] = 0;
            for(i=0;i<N[nf];i++)
                if (r[nf][i][2]>rH[nf])
                    rH[nf] = r[nf][i][2];
        }
    }


    // Verbose output: One line is written each iteration.
    if (verboseTF)
    {

        if ( (nt > NTCHECK && nt <= NTCHECK+200000) ) //only output 4000 runs, after initial transient
        {
        // output results to file
        fList = fopen(listName, "a");

        fprintf(fList, "%ld %f %f %f %f %f %ld",
                nt,                         // 1
                E,                          // 2
                dChi[0],                    // 3
                dChi[1],                    // 4
                rate[0],                    // 5
                rate[1],                    // 6
                constraintProposalsTotal);  // 7

        for(nf=0;nf<NFil;nf++)
        {

            fprintf(fList, " %f %f %f %f",
                    ree[nf],                // 8 + (4 + NFil + 3*iSiteTotal[nf] + 1 + 3 + 3*N[nf] + 3*iSiteTotal[nf] + 3)*nf
                    rM[nf],                 // 9
                    rH[nf],                 // 10
                    ksStatistic[nf]);       // 11

            for(nf2=0;nf2<NFil;nf2++)
            {
                fprintf(fList, " %f",
                        reeFil[nf][nf2]);   // 12 + nf2
            }

            for(iy=0;iy<iSiteTotal[nf];iy++)
            {
                fprintf(fList, " %ld %ld %ld",
                        stericOcclusion[nf][iy],                // 13 + (NFil-1) + 3*iy
                        membraneOcclusion[nf][iy],              // 14 + (NFil-1) + 3*iy
                        membraneAndSegmentOcclusion[nf][iy]);   // 15 + (NFil-1) + 3*iy
            }

            fprintf(fList, " %ld", stericOcclusionBase[nf]);    // 16 + (NFil-1) + 3*(iSiteTotal[nf]-1)

            if (VISUALIZE)
            {
                // print base locations
                fprintf(fList, " %f %f %f",
                        rBase[nf][0],   // 17 + (NFil-1) + 3*(iSiteTotal[nf]-1)
                        rBase[nf][1],   // 18 + (NFil-1) + 3*(iSiteTotal[nf]-1)
                        rBase[nf][2]);  // 19 + (NFil-1) + 3*(iSiteTotal[nf]-1)

                // print segment locations
                for (i=0;i<N[nf];i++)
                {
                    fprintf(fList, " %f %f %f",
                            r[nf][i][0],    // 20 + (NFil-1) + 3*(iSiteTotal[nf]-1) + 3*i
                            r[nf][i][1],    // 21 + (NFil-1) + 3*(iSiteTotal[nf]-1) + 3*i
                            r[nf][i][2]);   // 22 + (NFil-1) + 3*(iSiteTotal[nf]-1) + 3*i
                }

                // print iSite ligand centers
                for (iy=0;iy<iSiteTotal[nf];iy++)
                {
                    fprintf(fList, " %f %f %f",
                            iLigandCenter[nf][iy][0],    // 23 + (NFil-1) + 3*(iSiteTotal[nf]-1) + 3*(N[nf]-1) + 3*iy
                            iLigandCenter[nf][iy][1],    // 24 + (NFil-1) + 3*(iSiteTotal[nf]-1) + 3*(N[nf]-1) + 3*iy
                            iLigandCenter[nf][iy][2]);   // 25 + (NFil-1) + 3*(iSiteTotal[nf]-1) + 3*(N[nf]-1) + 3*iy
                }

                // print  base ligand centers
                fprintf(fList, " %f %f %f",
                        baseLigandCenter[nf][0],    // 26 + (NFil-1) + 3*(iSiteTotal[nf]-1) + 3*(N[nf]-1) + 3*iy
                        baseLigandCenter[nf][1],    // 27 + (NFil-1) + 3*(iSiteTotal[nf]-1) + 3*(N[nf]-1) + 3*iy
                        baseLigandCenter[nf][2]);   // 28 + (NFil-1) + 3*(iSiteTotal[nf]-1) + 3*(N[nf]-1) + 3*iy


                // print bound site ligand centers
                if(MULTIPLE)
                {
                    for (ib=0;ib<bSiteTotal[nf];ib++)
                    {
                        fprintf(fList, " %f %f %f",
                                bLigandCenter[nf][ib][0],    // 29 + (NFil-1) + 3*(iSiteTotal[nf]-1) + 3*(N[nf]-1) + 3*iy
                                bLigandCenter[nf][ib][1],    // 30 + (NFil-1) + 3*(iSiteTotal[nf]-1) + 3*(N[nf]-1) + 3*iy
                                bLigandCenter[nf][ib][2]);   // 31 + (NFil-1) + 3*(iSiteTotal[nf]-1) + 3*(N[nf]-1) + 3*iy
                    }
                }

            }

        } // end of filament loop (all output location numbers + (4 + NFil + 3*iSiteTotal[nf] + 1 + 3 + 3*N[nf] + 3*iSiteTotal[nf])*nf )


            if (VISUALIZE)
            {
                if(BASEBOUND)
                {
                    fprintf(fList," %f %f %f",
                            baseCenter[0],      // 1 + 7 + (4 + NFil + 3*iSiteTotal[nf] + 1 + 3 + 3*N[nf] + 3*iSiteTotal[nf] + 3 + MULTIPLE*3*bSiteTotal[nf])*NFil
                            baseCenter[1],      // 2 + 7 + (4 + NFil + 3*iSiteTotal[nf] + 1 + 3 + 3*N[nf] + 3*iSiteTotal[nf] + 3 + MULTIPLE*3*bSiteTotal[nf])*NFil
                            baseCenter[2]);     // 3 + 7 + (4 + NFil + 3*iSiteTotal[nf] + 1 + 3 + 3*N[nf] + 3*iSiteTotal[nf] + 3 + MULTIPLE*3*bSiteTotal[nf])*NFil
                }
            }

            fprintf(fList, "\n");
            fclose(fList);
        }
    } // finished verbose output

    // Note:  eliminates initial transient
    if (nt>NTCHECK)
    {
        // Summary statistics (these will be written at the end of the run)
        for(nf=0;nf<NFil;nf++)
        {
            reeBar_sum[nf]   += ree[nf];
            ree2Bar_sum[nf]  += ree[nf]*ree[nf];
        }

        for(nf=0;nf<NFil;nf++)
        {
            for(nf2=0;nf2<NFil;nf2++)
            {
                reeFilBar_sum[nf][nf2]   += reeFil[nf][nf2];
                ree2FilBar_sum[nf][nf2]  += reeFil[nf][nf2]*reeFil[nf][nf2];
            }
        }


        for(nf=0;nf<NFil;nf++)
        {
            ib=0;
            for(iy=0;iy<iSiteTotal[nf];iy++)
            {
                if(radtype == 10)
                {
                    Prvec0_rad[nf][iy] = Prvec0_op_rad[nf][iy] = Prvec_cen_rad[nf][iy] = Prvec_offcen_rad[nf][iy] = Prvec_offcen_op_rad[nf][iy] = Prvec0_up_rad[nf][iy] = Prvec0_up_op_rad[nf][iy] = Prvec_cen_up_rad[nf][iy] = Prvec_offcen_up_rad[nf][iy] = Prvec_offcen_up_op_rad[nf][iy] = Prvec0_halfup_rad[nf][iy] = Prvec0_halfup_op_rad[nf][iy] = Prvec_cen_halfup_rad[nf][iy] = Prvec_offcen_halfup_rad[nf][iy] = Prvec_offcen_halfup_op_rad[nf][iy] = (double)N[nf]/(double)NBINS;
                }else if (radtype == 20)
                {
                    Prvec0_rad[nf][iy] = Prvec0_op_rad[nf][iy] = Prvec_cen_rad[nf][iy] = Prvec_offcen_rad[nf][iy] = Prvec_offcen_op_rad[nf][iy] = Prvec0_up_rad[nf][iy] = Prvec0_up_op_rad[nf][iy] = Prvec_cen_up_rad[nf][iy] = Prvec_offcen_up_rad[nf][iy] = Prvec_offcen_up_op_rad[nf][iy] = Prvec0_halfup_rad[nf][iy] = Prvec0_halfup_op_rad[nf][iy] = Prvec_cen_halfup_rad[nf][iy] = Prvec_offcen_halfup_rad[nf][iy] = Prvec_offcen_halfup_op_rad[nf][iy] = ((double)iy+1)/(double)NBINS;
                }else if (radtype == 30)
                {
                    Prvec0_rad[nf][iy] = Prvec0_op_rad[nf][iy] = Prvec_cen_rad[nf][iy] = Prvec_offcen_rad[nf][iy] = Prvec_offcen_op_rad[nf][iy] = Prvec0_up_rad[nf][iy] = Prvec0_up_op_rad[nf][iy] = Prvec_cen_up_rad[nf][iy] = Prvec_offcen_up_rad[nf][iy] = Prvec_offcen_up_op_rad[nf][iy] = Prvec0_halfup_rad[nf][iy] = Prvec0_halfup_op_rad[nf][iy] = Prvec_cen_halfup_rad[nf][iy] = Prvec_offcen_halfup_rad[nf][iy] = Prvec_offcen_halfup_op_rad[nf][iy] = pow(((double)N[nf]*((double)iy+1)),0.5)/(double)NBINS;
                }else if (radtype == 40)
                {
                    Prvec0_rad[nf][iy] = Prvec0_op_rad[nf][iy] = Prvec_cen_rad[nf][iy] = Prvec_offcen_rad[nf][iy] = Prvec_offcen_op_rad[nf][iy] = Prvec0_up_rad[nf][iy] = Prvec0_up_op_rad[nf][iy] = Prvec_cen_up_rad[nf][iy] = Prvec_offcen_up_rad[nf][iy] = Prvec_offcen_up_op_rad[nf][iy] = Prvec0_halfup_rad[nf][iy] = Prvec0_halfup_op_rad[nf][iy] = Prvec_cen_halfup_rad[nf][iy] = Prvec_offcen_halfup_rad[nf][iy] = Prvec_offcen_halfup_op_rad[nf][iy] = (((double)N[nf]+((double)iy+1)))/(2*(double)NBINS);
                }else if (radtype == 50)
                {
                    if(iy>200)
                    {
                        Prvec0_rad[nf][iy] = Prvec0_op_rad[nf][iy] = Prvec_cen_rad[nf][iy] = Prvec_offcen_rad[nf][iy] = Prvec_offcen_op_rad[nf][iy] = Prvec0_up_rad[nf][iy] = Prvec0_up_op_rad[nf][iy] = Prvec_cen_up_rad[nf][iy] = Prvec_offcen_up_rad[nf][iy] = Prvec_offcen_up_op_rad[nf][iy] = Prvec0_halfup_rad[nf][iy] = Prvec0_halfup_op_rad[nf][iy] = Prvec_cen_halfup_rad[nf][iy] = Prvec_offcen_halfup_rad[nf][iy] = Prvec_offcen_halfup_op_rad[nf][iy] = (double)N[nf]/(double)NBINS;
                    }else{
                        Prvec0_rad[nf][iy] = Prvec0_op_rad[nf][iy] = Prvec_cen_rad[nf][iy] = Prvec_offcen_rad[nf][iy] = Prvec_offcen_op_rad[nf][iy] = Prvec0_up_rad[nf][iy] = Prvec0_up_op_rad[nf][iy] = Prvec_cen_up_rad[nf][iy] = Prvec_offcen_up_rad[nf][iy] = Prvec_offcen_up_op_rad[nf][iy] = Prvec0_halfup_rad[nf][iy] = Prvec0_halfup_op_rad[nf][iy] = Prvec_cen_halfup_rad[nf][iy] = Prvec_offcen_halfup_rad[nf][iy] = Prvec_offcen_halfup_op_rad[nf][iy] = ((double)iy+1)/(double)NBINS;
                    }
                }else{
                    Prvec0_rad[nf][iy] = Prvec0_op_rad[nf][iy] = Prvec_cen_rad[nf][iy] = Prvec_offcen_rad[nf][iy] = Prvec_offcen_op_rad[nf][iy] = Prvec0_up_rad[nf][iy] = Prvec0_up_op_rad[nf][iy] = Prvec_cen_up_rad[nf][iy] = Prvec_offcen_up_rad[nf][iy] = Prvec_offcen_up_op_rad[nf][iy] = Prvec0_halfup_rad[nf][iy] = Prvec0_halfup_op_rad[nf][iy] = Prvec_cen_halfup_rad[nf][iy] = Prvec_offcen_halfup_rad[nf][iy] = Prvec_offcen_halfup_op_rad[nf][iy] = (double)radtype;
                }
                
                POcclude_sum[nf][iy]         += (long)(stericOcclusion[nf][iy]>0);

                
                Prvec0_sum[nf][iy]           += (long)(reeiSite[nf][iy] < (double)Prvec0_rad[nf][iy]);
                Prvec0_up_sum[nf][iy]           += (long)(reeiSite_up[nf][iy] < (double)Prvec0_up_rad[nf][iy]);
                Prvec0_halfup_sum[nf][iy]           += (long)(reeiSite_halfup[nf][iy] < (double)Prvec0_halfup_rad[nf][iy]);

                if(iy==bSite[nf][ib])
                {
                    Prvec0_sum_bound[nf][iy][0]           += (long)(reeiSite_bound[nf][iy][0] < (double)Prvec0_rad[nf][iy]);
                    Prvec0_up_sum_bound[nf][iy][0]           += (long)(reeiSite_up_bound[nf][iy][0] < (double)Prvec0_up_rad[nf][iy]);
                    Prvec0_halfup_sum_bound[nf][iy][0]           += (long)(reeiSite_halfup_bound[nf][iy][0] < (double)Prvec0_halfup_rad[nf][iy]);

                    Prvec0_sum_bound[nf][iy][1]           += (long)(reeiSite_bound[nf][iy][1] < (double)Prvec0_rad[nf][iy]);
                    Prvec0_up_sum_bound[nf][iy][1]           += (long)(reeiSite_up_bound[nf][iy][1] < (double)Prvec0_up_rad[nf][iy]);
                    Prvec0_halfup_sum_bound[nf][iy][1]           += (long)(reeiSite_halfup_bound[nf][iy][1] < (double)Prvec0_halfup_rad[nf][iy]);

                    if(NFil<=2){
                        Prvec0_op_sum_bound[nf][iy][0]           += (long)(reeiSite_op_bound[nf][iy][0] < (double)Prvec0_op_rad[nf][iy]);
                        Prvec_cen_sum_bound[nf][iy][0]           += (long)(reeiSite_cen_bound[nf][iy][0] < (double)Prvec_cen_rad[nf][iy]);
                        Prvec_offcen_sum_bound[nf][iy][0]           += (long)(reeiSite_offcen_bound[nf][iy][0] < (double)Prvec_offcen_rad[nf][iy]);
                        Prvec_offcen_op_sum_bound[nf][iy][0]           += (long)(reeiSite_offcen_op_bound[nf][iy][0] < (double)Prvec_offcen_op_rad[nf][iy]);

                        Prvec0_up_op_sum_bound[nf][iy][0]           += (long)(reeiSite_up_op_bound[nf][iy][0] < (double)Prvec0_up_op_rad[nf][iy]);
                        Prvec_cen_up_sum_bound[nf][iy][0]           += (long)(reeiSite_cen_up_bound[nf][iy][0] < (double)Prvec_cen_up_rad[nf][iy]);
                        Prvec_offcen_up_sum_bound[nf][iy][0]           += (long)(reeiSite_offcen_up_bound[nf][iy][0] < (double)Prvec_offcen_up_rad[nf][iy]);
                        Prvec_offcen_up_op_sum_bound[nf][iy][0]           += (long)(reeiSite_offcen_up_op_bound[nf][iy][0] < (double)Prvec_offcen_up_op_rad[nf][iy]);

                        Prvec0_halfup_op_sum_bound[nf][iy][0]           += (long)(reeiSite_halfup_op_bound[nf][iy][0] < (double)Prvec0_halfup_op_rad[nf][iy]);
                        Prvec_cen_halfup_sum_bound[nf][iy][0]           += (long)(reeiSite_cen_halfup_bound[nf][iy][0] < (double)Prvec_cen_halfup_rad[nf][iy]);
                        Prvec_offcen_halfup_sum_bound[nf][iy][0]           += (long)(reeiSite_offcen_halfup_bound[nf][iy][0] < (double)Prvec_offcen_halfup_rad[nf][iy]);
                        Prvec_offcen_halfup_op_sum_bound[nf][iy][0]           += (long)(reeiSite_offcen_halfup_op_bound[nf][iy][0] < (double)Prvec_offcen_halfup_op_rad[nf][iy]);
                    }
                    ib++;
                }

                if(NFil<=2){
                    Prvec0_op_sum[nf][iy]           += (long)(reeiSite_op[nf][iy] < (double)Prvec0_op_rad[nf][iy]);
                    Prvec_cen_sum[nf][iy]           += (long)(reeiSite_cen[nf][iy] < (double)Prvec_cen_rad[nf][iy]);
                    Prvec_offcen_sum[nf][iy]           += (long)(reeiSite_offcen[nf][iy] < (double)Prvec_offcen_rad[nf][iy]);
                    Prvec_offcen_op_sum[nf][iy]           += (long)(reeiSite_offcen_op[nf][iy] < (double)Prvec_offcen_op_rad[nf][iy]);

                    Prvec0_up_op_sum[nf][iy]           += (long)(reeiSite_up_op[nf][iy] < (double)Prvec0_up_op_rad[nf][iy]);
                    Prvec_cen_up_sum[nf][iy]           += (long)(reeiSite_cen_up[nf][iy] < (double)Prvec_cen_up_rad[nf][iy]);
                    Prvec_offcen_up_sum[nf][iy]           += (long)(reeiSite_offcen_up[nf][iy] < (double)Prvec_offcen_up_rad[nf][iy]);
                    Prvec_offcen_up_op_sum[nf][iy]           += (long)(reeiSite_offcen_up_op[nf][iy] < (double)Prvec_offcen_up_op_rad[nf][iy]);

                    Prvec0_halfup_op_sum[nf][iy]           += (long)(reeiSite_halfup_op[nf][iy] < (double)Prvec0_halfup_op_rad[nf][iy]);
                    Prvec_cen_halfup_sum[nf][iy]           += (long)(reeiSite_cen_halfup[nf][iy] < (double)Prvec_cen_halfup_rad[nf][iy]);
                    Prvec_offcen_halfup_sum[nf][iy]           += (long)(reeiSite_offcen_halfup[nf][iy] < (double)Prvec_offcen_halfup_rad[nf][iy]);
                    Prvec_offcen_halfup_op_sum[nf][iy]           += (long)(reeiSite_offcen_halfup_op[nf][iy] < (double)Prvec_offcen_halfup_op_rad[nf][iy]);}

                for (j=0;j<Prvec_rad_vec_size;j++)
                {
                    Prvec0_sum_vec[nf][iy][j]           += (long)(reeiSite[nf][iy] < (double)Prvec_rad_vec[j]);
                    Prvec0_up_sum_vec[nf][iy][j]           += (long)(reeiSite_up[nf][iy] < (double)Prvec_rad_vec[j]);
                    Prvec0_halfup_sum_vec[nf][iy][j]           += (long)(reeiSite_halfup[nf][iy] < (double)Prvec_rad_vec[j]);

                    if(NFil<=2){
                        Prvec0_op_sum_vec[nf][iy][j]           += (long)(reeiSite_op[nf][iy] < (double)Prvec_rad_vec[j]);
                        Prvec_cen_sum_vec[nf][iy][j]           += (long)(reeiSite_cen[nf][iy] < (double)Prvec_rad_vec[j]);
                        Prvec_offcen_sum_vec[nf][iy][j]           += (long)(reeiSite_offcen[nf][iy] < (double)Prvec_rad_vec[j]);
                        Prvec_offcen_op_sum_vec[nf][iy][j]           += (long)(reeiSite_offcen_op[nf][iy] < (double)Prvec_rad_vec[j]);

                        Prvec0_up_op_sum_vec[nf][iy][j]           += (long)(reeiSite_up_op[nf][iy] < (double)Prvec_rad_vec[j]);
                        Prvec_cen_up_sum_vec[nf][iy][j]           += (long)(reeiSite_cen_up[nf][iy] < (double)Prvec_rad_vec[j]);
                        Prvec_offcen_up_sum_vec[nf][iy][j]           += (long)(reeiSite_offcen_up[nf][iy] < (double)Prvec_rad_vec[j]);
                        Prvec_offcen_up_op_sum_vec[nf][iy][j]           += (long)(reeiSite_offcen_up_op[nf][iy] < (double)Prvec_rad_vec[j]);

                        Prvec0_halfup_op_sum_vec[nf][iy][j]           += (long)(reeiSite_halfup_op[nf][iy] < (double)Prvec_rad_vec[j]);
                        Prvec_cen_halfup_sum_vec[nf][iy][j]           += (long)(reeiSite_cen_halfup[nf][iy] < (double)Prvec_rad_vec[j]);
                        Prvec_offcen_halfup_sum_vec[nf][iy][j]           += (long)(reeiSite_offcen_halfup[nf][iy] < (double)Prvec_rad_vec[j]);
                        Prvec_offcen_halfup_op_sum_vec[nf][iy][j]           += (long)(reeiSite_offcen_halfup_op[nf][iy] < (double)Prvec_rad_vec[j]);
                    }
                }

                PMembraneOcclude_sum[nf][iy] += (long)(membraneOcclusion[nf][iy]>0);
                PMembraneSegmentOcclude_sum[nf][iy] += (long)(membraneAndSegmentOcclusion[nf][iy]>0);

            }
        }

        // find how many iSites total are occluded
        iSitesOccluded_counter = 0;

        for(nf=0;nf<NFil;nf++)
        {
            for(iy=0;iy<iSiteTotal[nf];iy++)
            {
                iSitesOccluded_counter += (long)(stericOcclusion[nf][iy]>0);
            }
        }

        POcclude_NumSites_sum[(int)(iSitesOccluded_counter)] += 1;


        for(nf=0;nf<NFil;nf++)
        {
            POccludeBase_sum[nf]  += (long)(stericOcclusionBase[nf]>0);
            //PDeliver_sum[nf][ib] += (long)(boundToBaseDeliver[nf]>0);
            rMBar_sum[nf]    += rM[nf];
            rM2Bar_sum[nf]   += rM2[nf];
        }

        for(nf=0;nf<NFil;nf++)
        {
            for (iy=0;iy<iSiteTotal[nf];iy++)
            {

                reeiSiteBar_sum[nf][iy]   += reeiSite[nf][iy];
                ree2iSiteBar_sum[nf][iy]  += ree2iSite[nf][iy];

                rMiSiteBar_sum[nf][iy]    += rMiSite[nf][iy];
                rM2iSiteBar_sum[nf][iy]   += rM2iSite[nf][iy];
            }
        }

        // update bins for KS test (fabs(rM)+ree will never be larger than 2N, so use 2N to normalize)
        for(nf=0;nf<NFil;nf++)
        {
            convergenceVariableCounts[nf][(long)floor(NBINS*(fabs(rM[nf])+ree[nf])/(2*N[nf]))]++;
        }

        // Distributions for polymer location
        for(nf=0;nf<NFil;nf++)
        {
            for(i=0;i<N[nf];i++)
            {
                binCurrent = (long)floor(((double)r[nf][i][2]+N[nf])/binSize[nf]);
                polymerLocationCounts[nf][i][binCurrent]++;
            }
        }



        /* LOCAL CONCENTRATION */

        // initialize local concentration arrays

        if (MULTIPLE)
        {
            for(nf=0;nf<NFil;nf++)
            {
                for(iy=0; iy<iSiteTotal[nf];iy++)
                {
                    for(ib=0;ib<bSiteTotal[nf];ib++)
                    {
                        distiSiteToLigand[nf][iy][ib]  = 0;
                    }
                }
            }
            // calculate distance between each ligand and iSite center
            for(nf=0;nf<NFil;nf++)
            {
                for(iy=0;iy<iSiteTotal[nf];iy++)
                {
                    for(ib=0;ib<bSiteTotal[nf];ib++)
                    {
                        distiSiteToLigand[nf][iy][ib] = sqrt((iLigandCenter[nf][iy][0]-bLigandCenter[nf][ib][0])*
                                                             (iLigandCenter[nf][iy][0]-bLigandCenter[nf][ib][0])+
                                                             (iLigandCenter[nf][iy][1]-bLigandCenter[nf][ib][1])*
                                                             (iLigandCenter[nf][iy][1]-bLigandCenter[nf][ib][1])+
                                                             (iLigandCenter[nf][iy][2]-bLigandCenter[nf][ib][2])*
                                                             (iLigandCenter[nf][iy][2]-bLigandCenter[nf][ib][2]));
                    }
                }
            }

            // determine if distance is less than given cutoff AND iSite is not occluded
            for(nf=0;nf<NFil;nf++)
            {
                for(iy=0;iy<iSiteTotal[nf];iy++)
                {
                    // if iSite is not occluded
                    if(membraneAndSegmentOcclusion[nf][iy] == 0)
                    {
                        // test how far away each ligand is
                        for(ib=0;ib<bSiteTotal[nf];ib++)
                        {
                            if(distiSiteToLigand[nf][iy][ib] < localConcCutoff)
                            {
                                // if ligand is close enough (distance less than cutoff), ligand can bind
                                selfBind[nf][iy][ib]++;
                            }
                        }
                    }
                }
            }

        }

    }
	return;

}
