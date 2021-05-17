
import {
  ARTICLE_JSON_TAG_ATTRIBUTE, ARTICLE_JSON_PRIM_ATTRIBUTES, NODE_TYPE, ARTICLE_JSON_HEADER_TITLE, ARTICLE_JSON_BODY_VALUE, ARTICLE_JSON_TAG
} from '../fixtures/article_testdata.js';

import {
  getArticleHeader, getArticleBody, getArticleTag
} from '../page-objects/create_article';

describe('Validation of articles via JSON:API', ()=> {

  it(`Create and verify the created articles via JSON:API`,{ tags: '@JSON:API' }, ()=> {
    cy.createUser(Cypress.env('cyAdminUser'), Cypress.env('cyAdminPassword'), Cypress.env('cyAdminRole'));
    cy.getRestToken(Cypress.env('cyAdminUser'), Cypress.env('cyAdminPassword')).then(function (token) {
      cy.createTaxonomyTerm(token, ARTICLE_JSON_TAG_ATTRIBUTE).then(function ($uuid) {
        return cy.reseedArticle(token, NODE_TYPE, ARTICLE_JSON_PRIM_ATTRIBUTES, {
          field_tags: {
            data: {
              type: 'taxonomy_term--tags',
              id: $uuid
            }
          }
        })
      })
    }).then(node_id=> {
      cy.visit(`/en/node/${node_id}`);
      getArticleHeader().should('contain.text', ARTICLE_JSON_HEADER_TITLE);
      getArticleBody().should('contain.text', ARTICLE_JSON_BODY_VALUE);
      cy.visit(`/es/node/${node_id}`);
      getArticleHeader().should('contain.text', ARTICLE_JSON_HEADER_TITLE);
      getArticleTag().should('contain.text', ARTICLE_JSON_TAG);
      cy.logout();
    });
    cy.deleteUser(Cypress.env('cyAdminUser'));
  });

});
