
import {
  ARTICLE_JSON_TAG_ATTRIBUTE, ARTICLE_JSON_PRIM_ATTRIBUTES, NODE_TYPE, ARTICLE_JSON_HEADER_TITLE, ARTICLE_JSON_BODY_VALUE, ARTICLE_JSON_TAG
} from '../fixtures/article_testdata.js';

import {
  getArticleHeader, getArticleBody, getArticleTag
} from '../page-objects/create_article';

describe('Validation of articles via JSON:API', function () {

  // Commenting out as lando drush user:cancel in after function takes a long time to execute and throws timeout error
  /*before(function () {
    cy.createUser(Cypress.env('cyAdminUser'), Cypress.env('cyAdminPassword'), Cypress.env('cyAdminRole'));
  });*/

  it('Create and verify the created articles via JSON:API', function () {
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
    }).then(function (node_id) {
      cy.visit(`/en/node/${node_id}`);
      getArticleHeader().should('contain.text', ARTICLE_JSON_HEADER_TITLE);
      getArticleBody().should('contain.text', ARTICLE_JSON_BODY_VALUE);
      cy.visit(`/es/node/${node_id}`);
      getArticleHeader().should('contain.text', ARTICLE_JSON_HEADER_TITLE);
      getArticleTag().should('contain.text', ARTICLE_JSON_TAG);
      cy.logout();
    });
  });

  // Commenting out as lando drush user:cancel takes a long time to execute and throws timeout error
  /*after(function () {
    cy.deleteUser(Cypress.env('cyAdminUser'));
  });*/

});
